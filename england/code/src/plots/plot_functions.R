library(data.table)
library(ggplot2)
library(scales)


## SAVE PLOT
save_png <- function(file_name, w, h){
  ggsave(file_name, plot= last_plot(), w=w,h=h,units='cm')
}

## plot and save count graph
plot_count <- function(dt,save_file_name){
  plot_line_year_range(dt, "","Count of medications","")
  save_png(save_file_name, 20,20 )
}

## plot and save pct graph
plot_pct <- function(dt,save_file_name){
  plot_line_pct(dt, "","Percentage change yr on yr","")
  save_png(save_file_name, 20,20 )
}

## plot and save bar graph
plot_bar <- function(dt,save_file_name){
  plot_bar_count(dt, "","Count of medications","")
  save_png(save_file_name, 20,20 )
}

## for bar charts y scale lables
addUnits <- function(n) {
  
  labels <- ifelse(n < 1000, n,  # less than thousands
                   ifelse(n < 1e6, paste0(round(n/1e3), 'k'),  # in thousands
                          ifelse(n < 1e9, paste0(round(n/1e6), 'M'),  # in millions
                                 ifelse(n < 1e12, paste0(round(n/1e9), 'B'), # in billions
                                        ifelse(n < 1e15, paste0(round(n/1e12), 'T'), # in trillions
                                               'too big!'
                                        )))))
  return(labels)
}


## PLOT FOR COUNTS DATA
plot_line_year_range <- function(dt, title, y_title, x_title){
  
  v_dates = c(as.Date("2020-03-23"),as.Date("2020-10-31"),as.Date("2021-01-06"))
  
  p = ggplot( data=dt, aes(x=Date, y=count,  group=factor(strat_key), colour=factor(strat_key)) ) +
    
    geom_line() + ggtitle(title) +
    
    scale_x_date(breaks = "3 month",labels=date_format("%b\n%Y")) +
    
    theme_bw()+
    
    theme(legend.title = element_blank()) +
    
    geom_vline(xintercept=as.numeric(v_dates),
             linetype=4, colour="black") +
    
    scale_y_continuous(labels = addUnits) +
    
    ylab(x_title) + 
    ylab(y_title)
  
  p
  
}

## PLOT FOR PERCENTAGE DATA
plot_line_pct <- function(dt, title, y_title, x_title){
  
  v_dates = c(as.Date("2020-03-23"),as.Date("2020-10-31"),as.Date("2021-01-06"))
  
  p = ggplot( data=dt, aes(x=Date, y=pct,  group=factor(strat_key), colour=factor(strat_key)) ) +
    
    geom_line() + ggtitle(title) +
    
    scale_x_date(breaks = "3 month",labels=date_format("%b\n%Y")) +
    
    theme_bw()+
    
    theme(legend.title = element_blank()) +
    
    geom_vline(xintercept=as.numeric(v_dates),
               linetype=4, colour="black") +
    
    #scale_y_continuous(labels = addUnits) +
    
    ylab(x_title) + 
    ylab(y_title)
  
  p
  
}

## PLOT bar counts
plot_bar_count <- function(dt, title, y_title, x_title){
  
  ggplot(dt, aes(x=Date, y=count)) + 
    geom_bar(stat = "identity")
}




