# data
kospi <- kospi_20181012
rm(kospi_20181012)
# explore
str(kospi)
summary(kospi)

# preparation for prophet::facebook
kospi_sub <- subset(kospi, select = c(date, closing_price))
kospi_sub$date <- as.Date(kospi_sub$date)

if(!require(dplyr)){ 
  install.packages("dplyr")
  library(dplyr)
}
kospi_prophet <- rename(kospi_sub, ds = date, y = closing_price)


# prophet::facebook
if(!require(prophet)){ 
  install.packages("prophet")
  library(prophet)
}
m <- prophet(kospi_prophet, daily.seasonality = TRUE)

future <- make_future_dataframe(m, periods = 80)
tail(future)

forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat','yhat_lower', 'yhat_upper')])

plot(m, forecast)

prophet_plot_components(m, forecast)
