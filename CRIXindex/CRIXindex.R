rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

crix              = read.csv("crix.csv", header = FALSE)
crix$V1           = as.character(crix$V1)
last_substr       = substr(crix$V1, (nchar(crix$V1[1]) - 4), (nchar(crix$V1[1]) - 3))
last_substr_which = which(last_substr != c(last_substr[-1], tail(last_substr, n = 1))) + 1
last_substr_which = c(1, last_substr_which)
names_crix        = crix$V1[last_substr_which]

plot(crix[, 2], type = "l", col = "blue3", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of CRIX")
axis(1, at = last_substr_which, label = names_crix)