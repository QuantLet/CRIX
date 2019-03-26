# clean workspace
rm(list=ls(all=TRUE))

# Load needed Packages
libraries = c("ggplot2","scales","ggpubr")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# Authenticate
ga_auth()

ga_account_list()

CRIX_id = 'Type in your View ID here'


# Set your Parameters
start_date    = as.Date("2019-03-18",format = "%Y-%m-%d")
end_date      = as.Date("2019-03-25",format = "%Y-%m-%d")
overall_start = as.Date("2019-01-01",format = "%Y-%m-%d")



# Download Data
Crix_all        = google_analytics(CRIX_id,date_range = c(overall_start,end_date),metrics = c('pageviews'),dimensions = c('date'))
Crix_period     = google_analytics(CRIX_id,date_range = c(start_date,end_date),metrics = c('pageviews'),dimensions = c('date'))

# Define Ploting Function
graph = function(data = NULL,x = NULL, y = NULL, y_name = "Pageviews", output = NULL){
  g = ggplot(data = data, aes(x = x, y = y)) + geom_line() + 
    theme(panel.background = element_blank(), 
          plot.background = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line.x = element_line(color = "black"),
          axis.line.y = element_line(color = "black"),
          axis.text.y = element_text(size = 6),
          axis.text.x = element_text(angle = 45, hjust = 1),
          legend.key.size = unit(0.4, "cm")) + 
    scale_y_continuous(name=y_name,labels = scales::comma) + 
    xlab("Date") + labs(title="", subtitle = paste(y_name," between ",min(x)," to ",max(x))) +
    geom_hline(yintercept = mean(y),color = 'red', linetype = 'dashed') +
    annotate("text", x=min(x) + trunc(length(x)*0) , y=max(y)*0.95, label= paste("Daily Average:", round(mean(y),2)),hjust = 0) +
    annotate("text", x=min(x) + trunc(length(x)*0) , y=max(y)*0.9, label= paste("Daily Min:", round(min(y),2)),hjust = 0) +
    annotate("text", x=min(x) + trunc(length(x)*0) , y=max(y), label= paste("Daily Max:", round(max(y),2)),hjust = 0)
  ggsave(output, width = 6, height = 6, bg = "transparent")
  print(g)
}

# Create & Save Plots
graph(Crix_all,Crix_all$date,Crix_all$pageviews,"Pageviews","Overall_Pageviews.pdf")
graph(Crix_period,Crix_period$date,Crix_period$pageviews,"Pageviews","Overall_Pageviews_Period.pdf")
