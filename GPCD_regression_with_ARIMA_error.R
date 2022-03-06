require("nlme")

# data.csv
# historical dataest for fit
# columns (explanation): GPCD (monthly GPCD), Tem (temperature),	Pre (precipitation),
#	                        M1 (indicator variable Jan),	M2 (indicator variable Feb),	M3 (indicator variable Mar),	M4 (indicator variable Apr),	M5 (indicator variable May),	M6 (indicator variable Jun),	
#                         M7 (indicator variable Jul),  M8 (indicator variable Aug),	M9 (indicator variable Sep),	M10	(indicator variable Oct) ,M11 (indicator variable Nov),	M12 (indicator variable Dec),	
#                         Year (year for lower-GPCD fit),	Byear (year for higher-GPCD fit)
# Allxnew.csv
# dataset for predictoin
# Year, Byear, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12 are the same as before
# Temperatrue and precipitation are from 
#         Brekke, L., Thrasher, B. L., Maurer, E. P., and Pruitt, T. (2013). Downscaled CMIP3 and CMIP5 climate projections: Release of downscaled
#         CMIP5 climate projections, comparison with preceding information, and summary of user needs. U.S. Department of the Interior, Bureau of
#         Reclamation, Technical Services Center, Denver, CO, http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/, 
# Define each Temperature and Precipitation pair as  Temi and Prei (e.g, Tem1, Tem2, Pre1, Pre2, ...)

# Load data
TrainData <- read.csv(file="data.csv", header=TRUE, sep=",")
PredictionData <- read.csv(file="Allxnew.csv", header=TRUE, sep=",")

# lower-GPCD fit:  GLS with ARIMA (1,0,0) ×(1,0,0)11 errors
arima_year <- with(TrainData, arima(GPCD, order = c(1,0,0),seasonal = list(order = c(1, 0, 0),period=11),include.mean = FALSE, xreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Year)))
# get the coefficients and p-values and save
lower_pval=(1-pnorm(abs(arima_fit$coef)/sqrt(diag(arima_year$var.coef))))*2
lower_coefficients_table = data.frame(c(arima_year$coef),c(lower_pval))
write.table(lower_coefficients_table, "lower_coefficients_table.txt", sep="\t")

# higher-GPCD:  GLS with ARIMA (1,0,0) ×(1,0,0)11 errors
arima_byear <- with(TrainData, arima(GPCD, order = c(1,0,0),seasonal = list(order = c(1, 0, 0),period=11),include.mean = FALSE, xreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Byear)))
# get the coefficients and p-values and save
higher_pval=(1-pnorm(abs(arima_fit$coef)/sqrt(diag(arima_byear$var.coef))))*2
higher_coefficients_table = data.frame(c(arima_byear$coef),c(higher_pval))
write.table(higher_coefficients_table, "higher_coefficients_table.txt", sep="\t")

# Predict GPCD - assume there are 24 different Tem and Pre pairs
# GPCD_year_predict: prediction with lower-GPCD
# GPCD_byear_predict: prediction with higher-GPCD
GPCD_year_predict=NULL 
GPCD_byear_predict =NULL
for (i in 1:24){
  Tem = PredictionData[[paste(c("Tem", i), collapse = "")]]
  Pre = PredictionData[[paste(c("Pre", i), collapse = "")]]

  ypred<-c(with(PredictionData, predict(arima_year, newxreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Year))))
  bypred<-c(with(PredictionData, predict(arima_byear, newxreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Byear))))

  GPCD_year_predict=cbind(GPCD_year_predict,c(ypred$pred))
  GPCD_byear_predict=cbind(GPCD_byear_predict,c(bypred$pred))
}

# Save prediction result
write.table(GPCD_year_predict, "GPCD_year_predict.txt", sep="\t")
write.table(GPCD_byear_predict, "GPCD_byear_predict.txt", sep="\t")

