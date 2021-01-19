require("nlme")
MyData <- read.csv(file="input_data", header=TRUE, sep=",")

arima_fit <- with(MyData, arima(GPCD, order = c(1,0,0),seasonal = list(order = c(1, 0, 0),period=11),include.mean = FALSE, xreg = cbind(Tem, Pre, M1,M2,M3,M4,M5,M6,M7,M8,M9,M10,M11,M12,Year)))
pval=(1-pnorm(abs(arima_fit$coef)/sqrt(diag(arima_fit$var.coef))))*2
coefficients_table = data.frame(c(arima_fit$coef),c(pval))

x=residuals(arima_fit)
fitted=MyData$GPCD-x

write.table(fitted, "./result/fitted_low.txt", sep="\t")
write.table(x, "./result/residuals_low.txt", sep="\t")
write.table(coefficients_table, "./result/coefficients_table_low.txt", sep="\t")