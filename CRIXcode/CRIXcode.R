rm(list=ls(all=TRUE))

# please change your working directory
#setwd("C:/...")

# Specify index to compute, should be either CRIX, ECRIX, EFCRIX, 
# DAX or IPC. Default CRIX
chosen_index = "CRIX"

load("CryptoData.RData")
source("CRIXcodehelper.R")

# install and load packages
libraries = c("lubridate", "fBasics", "dgof", "ks", "KernSmooth", "zoo")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
    install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

base_value            = 1000
begin_date            = "01"
derivation_period     = 1
derivation_period_aic = 3
if (chosen_index == "DAX" || chosen_index == "IPC") {
    derivation_period     = 3
    derivation_period_aic = 3
}

switch(chosen_index,
    "CRIX"   = {market = coins_market
                   price  = coins_price
                   vol    = coins_vol},
    "ECRIX"  = {market = coins_market
                   price  = coins_price
                   vol    = coins_vol},
    "EFCRIX" = {market = coins_market
                   price  = coins_price
                   vol    = coins_vol},
    "DAX"    = {market = Germany_market
                   price  = Germany_price},
    "IPC"    = {market = Mexico_market
                   price  = Mexico_price}
)
  

if (chosen_index == "CRIX" || chosen_index == "ECRIX" || 
    chosen_index == "EFCRIX") {
    all_days  = sub('.*(?=.{2}$)', '', rownames(price), perl=T)
    days_line = which(begin_date == all_days)
} else if (chosen_index == "DAX") {
    all_days      = sub('.*(?=.{2}$)', '', rownames(price), perl=T)
    find_friday1  = which(diff(as.numeric(all_days)) < 0) + 1 
    find_friday2  = which(weekdays(as.Date(rownames(price))) == "Friday")
    find_friday3  = find_friday2[find_friday2 > 44]
    find_friday4  = find_friday1[-c(1, 2)]
    third_fridays = c() 
for (i in 2:length(find_friday4)) {
    third_fridays[i - 1] = find_friday3[find_friday3 >= find_friday4[i - 1] & 
    find_friday3 < find_friday4[i]][3]
}
    days_line = third_fridays + 1
} else if (chosen_index == "IPC") {
    all_days  = sub('.*(?=.{2}$)', '', rownames(price), perl = T)
    days_line = (which(diff(as.numeric(all_days)) < 0) + 1)[-c(1:5)]
}
index_periods = max(floor(derivation_period_aic / derivation_period), 1)
numb_aic1     = (length(days_line) - (derivation_period + 1)) / 
    derivation_period_aic
if ((numb_aic1%%1 == 0) == TRUE){
    numb_aic = numb_aic1 - 1
} else {
    numb_aic = floor(numb_aic1)
}

index_comp_numb = switch(chosen_index,
    "CRIX"   = {seq(5,dim(price)[[2]], 5)},
    "ECRIX"  = {seq(1,dim(price)[[2]], 1)},
    "EFCRIX" = {seq(1,dim(price)[[2]], 1)},
    "DAX"    = {seq(30,dim(price)[[2]], 5)},
    "IPC"    = {seq(35,dim(price)[[2]], 5)}
)

aic_matrix    = matrix(NA, nrow = numb_aic, ncol = length(index_comp_numb))
max_coin_numb = matrix(NA, nrow = 1, ncol = numb_aic)
for (per in 1:numb_aic){
    print(paste(per, " / ", numb_aic, sep = ""))
    current_lines         = days_line[seq((1 + derivation_period_aic * 
        (per - 1)), (derivation_period_aic * per + (derivation_period + 1)), 
    derivation_period)]
    begin_line            = current_lines[2]
    index_t_v_all         = index_comp_all("dummy", current_lines, begin_line, 
        TRUE, FALSE)
    max_coin_numb[1, per] = max(index_t_v_all[[2]])
for (per1 in 1:length(index_comp_numb)){
    index_t_v_numb = index_comp(index_comp_numb[per1], FALSE, current_lines, 
        begin_line, FALSE)
    plot_diff      = index_t_v_all[[1]] - index_t_v_numb[[1]]
    logLik1        = c()
for (cv1 in 1:length(plot_diff)){
    eva = try(with(density(plot_diff[-cv1], bw = dpik(plot_diff[-cv1], 
        kernel = "epanech", gridsize = 1601L), kernel = "epanechnikov"), 
        approxfun(x, y, yleft = 0.00000000000000000001, 
        yright = 0.00000000000000000001)), silent = T)
if (class(eva) == "try-error"){
    break
}
    eva1         = eva(plot_diff[cv1])
    logLik1[cv1] = log(eva1)
}
if (class(eva) == "try-error"){
    break
}
    logLik                = sum(logLik1)
    aic_matrix[per, per1] = 2 * index_comp_numb[per1] - 2 * logLik
if (chosen_index == "CRIX" || chosen_index == "ECRIX" || 
    chosen_index == "DAX" || chosen_index == "IPC") {
if (per1 >= 2){
if (aic_matrix[per, per1] > aic_matrix[per, per1 - 1]){
    break
}
}
}
}
if (chosen_index == "CRIX" || chosen_index == "ECRIX" || 
    chosen_index == "DAX" || chosen_index == "IPC") {
if (per1 > 1) {
    index_members = index_comp_numb[per1 - 1]
} else if (per1 == 1) {
    index_members = index_comp_numb[per1]
}
} else if (chosen_index == "EFCRIX") {
    index_members = which.min(aic_matrix[per,])
}
    current_lines1 = days_line[seq((1 + derivation_period_aic * (per)), 
        (derivation_period_aic * (per + 1) + (derivation_period + 1)), 
        derivation_period)]
    begin_line1    = current_lines1[2]
    crix1          = index_comp(index_members, TRUE, current_lines1, 
        begin_line1, TRUE)
while (is.null(crix1)){
    index_members = index_members - 1
    crix1         = index_comp(index_members, TRUE, current_lines1, begin_line1, 
        TRUE)
}
    crix2     = crix1[[1]]
    crix_all2 = index_comp_all("dummy", current_lines1, begin_line1, 
        FALSE, TRUE)
    crix_all1 = crix_all2[[1]]
    crix_all4 = index_comp_all("dummy", current_lines1, begin_line1, TRUE, TRUE)
    crix_all3 = crix_all4[[1]]
if (per == 1){
    crix          = do.call(cbind,list(crix2))
    crix_all      = do.call(cbind,list(crix_all1))
    crix_all_comp = do.call(cbind,list(crix_all3))
} else {
    crix          = rbind(crix, do.call(cbind, list(crix2)))
    crix_all      = rbind(crix_all, do.call(cbind, list(crix_all1)))
    crix_all_comp = rbind(crix_all_comp, do.call(cbind, list(crix_all3)))
}
}

