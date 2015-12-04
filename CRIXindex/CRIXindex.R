rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

plot_crix         = read.csv("crix.csv", header = T, row.names = 1)
line_index        = rep(1000, dim(plot_crix)[1])
names(line_index) = rownames(plot_crix)
plot_xaxis        = c(as.Date(rownames(plot_crix)[1]) - 1, 
  as.Date(rownames(plot_crix)))
plot(c(1000, plot_crix$Price), type = "l", col = "blue3", lwd = 3, 
  ylim = c(min(plot_crix) - 30, max(plot_crix) + 30), xlab = "Date", 
  ylab = "CRIX value", xaxt = "n")
axis(1, at = c(2, 94, 186, 275, 367), 
  labels = plot_xaxis[c(2, 94, 186, 275, 367)])
lines(line_index, type = "l", lwd = 3) 
