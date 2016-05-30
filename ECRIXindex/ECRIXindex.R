rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

load("ecrix.RData")

plot(ecrix, type = "l", col = "red3", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of ECRIX")
axis(1, at = c(2,94,186,275,367,459,551), label = names(ecrix)[c(2,94,186,275,367,459,551)])
