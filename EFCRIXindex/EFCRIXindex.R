rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

load("efcrix.RData")

plot(efcrix, type = "l", col = "darkgreen", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of EFCRIX")
axis(1, at = c(2,94,186,275,367,459,551), label = names(efcrix)[c(2,94,186,275,367,459,551)])
