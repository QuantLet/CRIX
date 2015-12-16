
[<img src="https://github.com/QuantLet/Styleguide-and-Validation-procedure/blob/master/pictures/banner.png" alt="Visit QuantNet">](http://quantlet.de/index.php?p=info)

## [<img src="https://github.com/QuantLet/Styleguide-and-Validation-procedure/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **ECRIXindex** [<img src="https://github.com/QuantLet/Styleguide-and-Validation-procedure/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/d3/ia)

```yaml

Name of Quantlet : ECRIXindex

Published in :  'CRIX - a CRyptocurrency IndeX'

Description : ECRIXindex gives a plot which shows the performance of the cryptocurrency index ECRIX.

Keywords : 
 - CRIX
 - ECRIX
 - index
 - cryptocurrency
 - crypto
 - plot

See also : 
 - CRIXindex
 - EFCRIXindex
 - CRIXfamdiff
 - CRIXfamdiffloss
 - DAXCRIXloss
 - CRIXhnoptions
 - CRIXoutmarket
 - CRIXoutmarketTERES
 - CRIXvarreturn

Author : Simon Trimborn

Submitted :  Fri, December 12 2015 by Simon Trimborn

Datafile : ecrix.csv

Example : Plot with the ECRIX.
```

![Picture1](ECRIXindex_plot.png)


```r
rm(list = ls(all = TRUE))
graphics.off()

# please change your working directory 
# setwd('C:/...')

ecrix = read.csv("ecrix.csv", header = FALSE)
ecrix$V1 = as.character(ecrix$V1)
last_substr = substr(ecrix$V1, (nchar(ecrix$V1[1]) - 4), 
    (nchar(ecrix$V1[1]) - 3))
last_substr_which = which(last_substr != c(last_substr[-1], tail(last_substr, 
    n = 1))) + 1
last_substr_which = c(1, last_substr_which)
names_crix = ecrix$V1[last_substr_which]

plot(ecrix[, 2], type = "l", col = "red3", xaxt = "n", lwd = 3, xlab = "Date", 
     ylab = "Performance of ECRIX")
axis(1, at = last_substr_which, label = names_crix)
```
