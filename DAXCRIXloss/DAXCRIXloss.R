rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

dax         = read.csv("DAXcsv.csv", sep = ";", dec = ",", header = FALSE)
daxcrix     = read.csv("daxcrix.csv", sep = ",", dec = ".", header = FALSE)
totalmarket = read.csv("totalmarket.csv", sep = ",", dec = ".", header = FALSE)

date_dax        = as.Date(dax[, 1], format = "%d.%m.%Y")
date_daxcrix    = as.Date(daxcrix[, 1], origin = "1970-01-01")
divisor_dax     = dax[which(date_dax == date_daxcrix[1] - 3), 2] / 1000
dax_rescaled    = dax[c(which(date_dax == date_daxcrix[1]):which(date_dax == 
    tail(date_daxcrix, n = 1))), 2] / divisor_dax
daxcrix_analyze = daxcrix[, 2]

mse_daxcrix_daxcrixall = mean((totalmarket[, 2] - daxcrix_analyze)^2)
mda_daxcrix_daxcrixall = mean(sign(diff(totalmarket[, 2])) == 
    sign(diff(daxcrix_analyze)))
mse_dax_daxcrixall = mean((totalmarket[, 2] - dax_rescaled)^2)
mda_dax_daxcrixall = mean(sign(diff(totalmarket[, 2])) == 
    sign(diff(dax_rescaled)))
matrix_mse_mda = matrix(round(c(mse_daxcrix_daxcrixall, mse_dax_daxcrixall, 
    mda_daxcrix_daxcrixall, mda_dax_daxcrixall), 2), ncol = 2, byrow = FALSE, 
    dimnames = list(c("DAXCRIX vs. Total Market", "DAX vs. Total Market"), 
    c("MSE", "MDA")))
matrix_mse_mda