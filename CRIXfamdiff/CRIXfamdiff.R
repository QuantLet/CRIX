rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

load("crix.RData")
load("ecrix.RData")
load("efcrix.RData")
load("TMI.RData")

plot(TMI - crix, type = "l", col = "blue3", xaxt = "n", lwd = 3, 
  xlab = "Date", ylab = "Difference between Indices and Total Market", 
  ylim = c(min(TMI - crix, TMI - ecrix, 
  TMI - efcrix), max(TMI - crix, TMI - 
  ecrix, TMI - efcrix)))
lines(TMI - ecrix, type = "l", col = "red3", lwd = 3)
lines(TMI - efcrix, type = "l", col = "darkgreen", lwd = 3)
axis(1, at = c(2,94,186,275,367,459,551), label = names(crix)[c(2,94,186,275,367,459,551)])
