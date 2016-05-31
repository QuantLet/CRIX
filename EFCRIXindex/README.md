
[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="880" alt="Visit QuantNet">](http://quantlet.de/index.php?p=info)

## [<img src="https://github.com/QuantLet/Styleguide-and-Validation-procedure/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **EFCRIXindex** [<img src="https://github.com/QuantLet/Styleguide-and-Validation-procedure/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/d3/ia)

```yaml

Name of Quantlet : EFCRIXindex

Published in : CRIX or evaluating blockchain based currencies

Description : 'Gives a plot which shows the performance of the cryptocurrency index EFCRIX. The
data were calculated with CRIXcode.R.'

Keywords : CRIX, ECRIX, EFCRIX, index, cryptocurrency, crypto, plot

See also : 'CRIXindex, ECRIXindex, CRIXfamdiff, CRIXfamdiffloss, DAXCRIXloss, CRIXhnoptions,
CRIXoutmarket, CRIXoutmarketTERES, CRIXvarreturn'

Author : Simon Trimborn

Submitted : Mon, May 30 2016 by Simon Trimborn

Datafile : efcrix.RData

Example : Plot with the EFCRIX.

```

![Picture1](EFCRIXindex_plot.png)


### R Code:
```r
rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

load("efcrix.RData")

plot(efcrix, type = "l", col = "darkgreen", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of EFCRIX")
axis(1, at = c(2,94,186,275,367,459,551), label = names(efcrix)[c(2,94,186,275,367,459,551)])

```
