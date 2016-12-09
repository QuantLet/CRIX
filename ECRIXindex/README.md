
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **ECRIXindex** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml

Name of Quantlet : ECRIXindex

Published in : CRIX or evaluating blockchain based currencies

Description : 'Gives a plot which shows the performance of the cryptocurrency index ECRIX. The data
were calculated with CRIXcode.R.'

Keywords : CRIX, ECRIX, index, cryptocurrency, crypto, plot

See also : 'CRIXindex, EFCRIXindex, CRIXfamdiff, CRIXfamdiffloss, FDAXloss, CRIXhnoptions,
CRIXoutmarket, CRIXoutmarketTERES, CRIXvarreturn'

Author : Simon Trimborn

Submitted : Mon, May 30 2016 by Simon Trimborn

Datafile : ecrix.RData

Example : Plot with the ECRIX.

```

![Picture1](ECRIXindex_plot.png)


### R Code:
```r
rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

load("ecrix.RData")

plot(ecrix, type = "l", col = "red3", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of ECRIX")
axis(1, at = c(2,94,186,275,367,459,551), label = names(ecrix)[c(2,94,186,275,367,459,551)])

```
