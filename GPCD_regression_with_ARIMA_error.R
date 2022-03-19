# This R script provides two monthly Gallons Per Capita per Day (GPCD) models in Section 4.3.2 Water Demand Prediction - Building Statistical Models 
# in "A Multistage Distributionally Robust Optimization Approach to Water Allocation under Climate Uncertainty", https://arxiv.org/pdf/2005.07811.pdf.
# Both models use Generalized Least Squares with seasonal AutoRegressive Integrated Moving Average (ARIMA), ARIMA (1, 0, 0)× (1, 0, 0)_(11) errors.

# Load Linear and Nonlinear Mixed Effects Models Package
require("nlme")

# Restrict year variable Please fill out the below y_low and y_upper for higher-GPCD
y_low = 
y_upper = 

# regression_input_data.csv
# historical dataest for fit
# columns (explanation): GPCD (monthly GPCD), Tem (temperature -- average daily temperature in Celsius),	Pre (precipitation – average daily precipitation in mm),
#	                        M1 (indicator variable Jan),	M2 (indicator variable Feb),	M3 (indicator variable Mar),	M4 (indicator variable Apr),	M5 (indicator variable May),	M6 (indicator variable Jun),	
#                         M7 (indicator variable Jul),  M8 (indicator variable Aug),	M9 (indicator variable Sep),	M10	(indicator variable Oct) ,M11 (indicator variable Nov),	M12 (indicator variable Dec),	
#                         Year (Year of data)
# Testing_X_values
# dataset for prediction
# Year, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12 are the same as before
# Temperatrue and precipitation are from 
#         Brekke, L., Thrasher, B. L., Maurer, E. P., and Pruitt, T. (2013). Downscaled CMIP3 and CMIP5 climate projections: Release of downscaled
#         CMIP5 climate projections, comparison with preceding information, and summary of user needs. U.S. Department of the Interior, Bureau of
#         Reclamation, Technical Services Center, Denver, CO, http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/, 
# Define each Temperature and Precipitation pair as  Temi and Prei (e.g, Tem1, Tem2, Pre1, Pre2, ...)

# Load data
TrainData <- read.csv(file="regression_input_data.csv", header=TRUE, sep=",")
PredictionData <- read.csv(file="Testing_X_values.csv", header=TRUE, sep=",")

# lower-GPCD fit:  GLS with ARIMA (1,0,0) ×(1,0,0)11 errors
arima_year <- with(TrainData, arima(GPCD, order = c(1,0,0),seasonal = list(order = c(1, 0, 0),period=11),include.mean = FALSE, xreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Year)))
# get the coefficients and p-values and save
lower_pval=(1-pnorm(abs(arima_year$coef)/sqrt(diag(arima_year$var.coef))))*2
lower_coefficients_table = data.frame(c(arima_year$coef),c(lower_pval))
write.table(lower_coefficients_table, "lower_coefficients_table.txt", sep="\t")

# higher-GPCD:  GLS with ARIMA (1,0,0) ×(1,0,0)11 errors
# Restrict year variable 
TrainData$Byear = TrainData$Year 
TrainData$Byear[TrainData$Byear <= y_low] <- y_low
TrainData$Byear[TrainData$Byear >= y_upper] <- y_upper

arima_byear <- with(TrainData, arima(GPCD, order = c(1,0,0),seasonal = list(order = c(1, 0, 0),period=11),include.mean = FALSE, xreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Byear)))
# get the coefficients and p-values and save
higher_pval=(1-pnorm(abs(arima_year$coef)/sqrt(diag(arima_byear$var.coef))))*2
higher_coefficients_table = data.frame(c(arima_byear$coef),c(higher_pval))
write.table(higher_coefficients_table, "higher_coefficients_table.txt", sep="\t")

# Predict GPCD - assume there are 24 different Tem and Pre pairs
# GPCD_year_predict: prediction with lower-GPCD
# GPCD_byear_predict: prediction with higher-GPCD
GPCD_year_predict=NULL 
GPCD_byear_predict =NULL

# Restrict year variable 
PredictionData$Byear = PredictionData$Year 
PredictionData$Byear[PredictionData$Byear <= y_low] <- y_low
PredictionData$Byear[PredictionData$Byear >= y_upper] <- y_upper
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

