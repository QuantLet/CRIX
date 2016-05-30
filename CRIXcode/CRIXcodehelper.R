index_comp = function(index_const, order_derive, current_lines_func, 
    begin_line_func, comp1){
  
index             = list()
index_members_m   = list()
index_members_t   = list()
order_market_list = list()
  
if (per == 1){
    index_value = base_value
} else if (comp1 == T) {
    index_value = tail(crix[, 1], n = 1)
} else if (comp1 == F){
    index_value = base_value
}
  ##########################################################
  ############## for loop for index computation ############
  ##########################################################
for (i in 1:(index_periods)){
    if (i == 1){
        last_index_period_time   = price[current_lines_func[1]:(
            current_lines_func[2] - 1), ]
        last_index_period_market = market[current_lines_func[1]:(
            current_lines_func[2] - 1), ]
    if (chosen_index == "CRIX") {
        last_index_period_vol = vol[current_lines_func[1]:(
            current_lines_func[2] - 1), ]}
    if (chosen_index == "CRIX") {
        omit_last = Reduce(intersect, list(which(apply(is.na(
            last_index_period_time), 2, any)
            == F), which(apply(is.na(last_index_period_market), 2, any) == F), 
            which(apply(is.na(last_index_period_vol), 2, any) == F)))
    } else {
        omit_last = Reduce(intersect, list(which(apply(is.na(
            last_index_period_time), 2, any)
            == F), which(apply(is.na(last_index_period_market), 2, any) == F)))
    }
    last_index_period_time   = last_index_period_time[, omit_last]
    last_index_period_market = last_index_period_market[, omit_last]
    if (chosen_index == "CRIX") {
        last_index_period_vol = last_index_period_vol[, omit_last]
    }
    omit_last_zero           = Reduce(intersect, list(which(apply(
        last_index_period_time == 0, 2, any) == F), which(apply(
        last_index_period_market == 0, 2, any) == F)))
    last_index_period_time   = last_index_period_time[, omit_last_zero]
    last_index_period_market = last_index_period_market[, omit_last_zero]
    if (chosen_index == "CRIX") {
        last_index_period_vol = last_index_period_vol[, omit_last_zero]
    }
    } else {
        if (chosen_index == "CRIX") {
            omit_now = Reduce(intersect, list(which(apply(is.na(
                index_period_time), 2, any) == F), which(apply(
                is.na(index_period_market), 2, any) == F), which(apply(
                is.na(index_period_vol), 2, any) == F)))
        } else {
            omit_now = Reduce(intersect, list(which(apply(is.na(
                index_period_time), 2, any)
                == F), which(apply(is.na(index_period_market), 2, any) == F)))
        }
    last_index_period_time    = index_period_time[, omit_now]
    last_index_period_market  = index_period_market[, omit_now]
    if (chosen_index == "CRIX") {
        last_index_period_vol = index_period_vol[, omit_now]
    }
    omit_now_zero            = Reduce(intersect, list(which(apply(
        index_period_time == 0, 2, any) == F), which(apply(
        index_period_market == 0, 2, any) == F)))
    last_index_period_time   = index_period_time[, omit_now_zero]
    last_index_period_market = index_period_market[, omit_now_zero]
    if (chosen_index == "CRIX") {
        last_index_period_vol = index_period_vol[, omit_now_zero]
    }
    }
    
    if (dim(last_index_period_market)[2] <= index_const){
      return(NULL)
    }
    
    last_line = if (i == 1){
        begin_line_func
    } else {
        next_line
    } 
    break_loop = FALSE
    if (per == numb_aic & is.na(current_lines_func[i + (2)]) == T) {
        next_line = length(all_days) + 1
        break_loop = TRUE
    } else {
        next_line = current_lines_func[i + 2]
    }
    last_index_time   = price[(last_line - 1), ]
    last_index_market = market[(last_line - 1), ]
    if (chosen_index == "CRIX") {
        last_index_vol = vol[(last_line - 1), ]  
    }
    if (chosen_index == "CRIX") {
        ### Liquidity rule 1: 
        adtv_cryptos = apply(last_index_period_vol, 2, mean)
        adtv_perc    = quantile(adtv_cryptos, 0.25)
        adtv_which   = which(adtv_cryptos >= adtv_perc)
        ### Liquidity rule 2: 
        adtc_cryptos = apply((last_index_period_vol / last_index_period_time), 
            2, mean)
        adtc_perc    = quantile(adtc_cryptos, 0.25)
        adtc_which   = which(adtc_cryptos >= adtc_perc)
        w_take       = unique(adtv_which, adtc_which)
        if (length(w_take) != 0){
            last_index_period_time   = last_index_period_time[, w_take]
            last_index_period_market = last_index_period_market[, w_take]
            last_index_period_vol    = last_index_period_vol[, w_take]
        }
    }
    
    order_market = order(last_index_market[colnames(last_index_period_market)], 
        decreasing = T)
    if (order_derive == T){
        order_market_list = append(order_market_list, list(colnames(
            last_index_period_time[, order_market])))
    }
    
    if (chosen_index == "CRIX") {
        if (length(w_take) >= index_const){
            order_market = order_market[1:index_const]
        } else {
            order_market = order_market[1:length(w_take)]
        }
    } else if (chosen_index == "ECRIX" || chosen_index == "EFCRIX" || 
        chosen_index == "DAX" || chosen_index == "IPC") {
        if (length(order_market) >= index_const){
            order_market = order_market[1:index_const]
        }
    }
    
    index_members_m[[i]]     = colnames(last_index_period_market)[order_market]
    index_members_t[[i]]     = colnames(last_index_period_time)[order_market]
    last_index_period_time   = last_index_period_time[, order_market]
    last_index_period_market = last_index_period_market[, order_market]
    if (chosen_index == "CRIX") {
        last_index_period_vol = last_index_period_vol[, order_market]
    }
    
    if (is.null(dim(last_index_period_market)) == T) {
        if (i == 1){
            divisor = sum(tail(last_index_period_market, n = 1)) / index_value
        } else if (i > 1){
            divisor = sum(last_index_market[index_members_m[[i]]]) / 
                index[[i - 1]][length(index[[i - 1]])]
        }
    } else {
        if (i == 1){
            divisor = sum(tail(last_index_period_market[, index_members_m[[i]]], 
                n = 1)) / index_value
        } else if (i > 1){
            divisor = sum(last_index_market[index_members_m[[i]]]) / 
                index[[i - 1]][length(index[[i - 1]])]
        }
    }
    
    index_period_time   = price[last_line:(next_line - 1),]
    index_period_market = market[last_line:(next_line - 1),]
    if (chosen_index == "CRIX") {
        index_period_vol = vol[last_line:(next_line - 1),]
    }
    
    index_period_time1   = na.locf(price)[last_line:(next_line - 1),]
    index_period_market1 = na.locf(market)[last_line:(next_line - 1),]
    if (chosen_index == "CRIX") {
        index_period_vol1 = na.locf(vol)[last_line:(next_line - 1),]
    }
    
    index_old_amount = (last_index_market)[index_members_m[[i]]] / 
        (last_index_time)[index_members_t[[i]]]
    if (is.null(dim(index_period_time1))) {
        index_comp1 = t(index_old_amount * t(index_period_time1[
            index_members_t[[i]]]))
        index[[i]] = sum(index_comp1)
    } else {
        index_comp1 = t(index_old_amount * t(index_period_time1[, 
            index_members_t[[i]]]))
        index[[i]] = apply(index_comp1, 1, sum)
    }
    index[[i]] = index[[i]] / divisor
    
    if (break_loop == T){
        break
    }
} # end for loop
  
################### Index derivation done
# building whole index time series
plot_index = c()
for (i in 1:length(index)){
    plot_index = c(plot_index, index[[i]])
}
  
list(plot_index, order_market_list)
}

# end function

##### begin function all ####

index_comp_all = function(index_const, current_lines_func, begin_line_func, 
    comp, comp1){
  
index           = list()
index_members_m = list()
index_members_t = list()
full_coin_numb  = c()
  
if (per == 1){
    index_value = base_value
} else if (comp1 == T){
    if (comp == T){
        index_value = tail(crix[, 1], n = 1)[[1]]
    } else {
        index_value = tail(crix_all[, 1], n = 1)[[1]]
    }
} else if (comp1 == F){
    index_value = base_value
}
  
##########################################################
############## for loop for index computation ############
##########################################################
for ( i in 1:(index_periods)){
    if (i == 1){
        last_index_period_time   = price[current_lines_func[1]:(
            current_lines_func[2] - 1),]
        last_index_period_market = market[current_lines_func[1]:(
            current_lines_func[2] - 1),]
        omit_last                = Reduce(intersect, list(which(apply(is.na(
            last_index_period_time), 2, any) == F), which(apply(is.na(
            last_index_period_market), 2, any) == F)))
        last_index_period_time   = last_index_period_time[, omit_last]
        last_index_period_market = last_index_period_market[, omit_last]
        omit_last_zero           = Reduce(intersect, list(which(apply(
            last_index_period_time == 0, 2, any) == F), which(apply(
            last_index_period_market == 0, 2, any) == F)))
        last_index_period_time   = last_index_period_time[, omit_last_zero]
        last_index_period_market = last_index_period_market[, omit_last_zero]
    } else {
        omit_now                 = Reduce(intersect, list(which(apply(is.na(
            index_period_time), 2, any) == F), which(apply(is.na(
            index_period_market), 2, any) == F)))
        last_index_period_time   = index_period_time[, omit_now]
        last_index_period_market = index_period_market[, omit_now]
        omit_now_zero            = Reduce(intersect, list(which(apply(
            index_period_time == 0, 2, any) == F), which(apply(
            index_period_market == 0, 2, any) == F)))
        last_index_period_time   = index_period_time[, omit_now_zero]
        last_index_period_market = index_period_market[, omit_now_zero]
    }
    
    last_line = if (i == 1){
        begin_line_func
    } else {
        next_line
    }
    break_loop = FALSE
    if (per == numb_aic & is.na(current_lines_func[i + 2]) == T) {
        next_line  = length(all_days) + 1
        break_loop = TRUE
    } else {
        next_line = current_lines_func[i + 2]
    }
    
    last_index_time          = price[(last_line - 1),]
    last_index_market        = market[(last_line - 1),]
    order_market             = order(last_index_market[colnames(
        last_index_period_market)], decreasing = T)
    last_index_period_time   = last_index_period_time[, order_market]
    last_index_period_market = last_index_period_market[, order_market]
    full_coin_numb           = c(full_coin_numb, dim(last_index_period_time)[2])
    index_members_m[[i]]     = colnames(last_index_period_market)
    index_members_t[[i]]     = colnames(last_index_period_time)
    if (i == 1){
        divisor = sum(tail(last_index_period_market[, index_members_m[[i]]], 
            n = 1)) / index_value
    } else if (i > 1){
        divisor = sum(last_index_market[index_members_m[[i]]]) / 
            index[[i - 1]][length(index[[i - 1]])]
    }
    
    index_period_time    = price[last_line:(next_line - 1),]
    index_period_market  = market[last_line:(next_line - 1),]
    index_period_time1   = na.locf(price)[last_line:(next_line - 1),]
    index_period_market1 = na.locf(market)[last_line:(next_line - 1),]
    index_old_amount     = (last_index_market)[index_members_m[[i]]] / 
        (last_index_time)[index_members_t[[i]]]
    if (is.null(dim(index_period_time1))) {
        index_comp1 = t(index_old_amount * t(index_period_time1[
            index_members_t[[i]]]))
        index[[i]]  = sum(index_comp1)
    } else {
        index_comp1 = t(index_old_amount * t(index_period_time1[, 
            index_members_t[[i]]]))
        index[[i]]  = apply(index_comp1, 1, sum)
    }
    index[[i]] = index[[i]] / divisor
    if (break_loop == T){
        break
    }
} # end for loop
  
################### Index derivation done
########## checking of the index ###################
# building whole index time series
plot_index = c()
for (i in 1:length(index)){
    plot_index = c(plot_index, index[[i]])
}
  
list(plot_index, full_coin_numb)
}

# end function