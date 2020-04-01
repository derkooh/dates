library(lubridate)
library(timeDate)
# library(busdater)
library(tidyr)
library(dplyr)

setwd("~/git/dates")

st <- as.Date("1950-01-01")
en <- as.Date("2099-12-31")


getMonth <- function(i){
  mymonths <- c("Jan","Feb","Mar",
                "Apr","May","Jun",
                "Jul","Aug","Sep",
                "Oct","Nov","Dec")
  return(mymonths[i])
}


dd <- ymd(seq(en, st, by = "-1 day"))

v1 <- as.character(seq( from = 1, to = length(dd)))


df <- data.frame(
  'date' = dd,
  'month' = month(dd),
  'monthname' = getMonth(month(dd)),
  'day' = day(dd),
  'year' = year(dd),
  
  'fod' = floor_date(dd, "day") + hours(0) + seconds(0.01),
  'eod' = dd + hours(24) - seconds(0.01),
  
  'fow' = floor_date(dd, "week") + hours(0) + seconds(0.01),
  'eow' = as_datetime(ceiling_date(dd, "week")) - seconds(0.01),
  
  'fom' = floor_date(dd, "month") + seconds(0.01),
  'eom' = ymd_hms(timeLastDayInMonth(dd) + hours(24) - seconds(0.01)),
  
  'foq' = floor_date(dd, "quarter") + hours(0) + seconds(0.01),
  'eoq' = as_datetime(ceiling_date(dd, "quarter")) - seconds(0.01),
  
  'foy' = floor_date(dd, "year") + seconds(0.01),
  'eoy' = ceiling_date(dd, "year") - seconds(0.01),
  
  'dow' = weekdays(dd),
  'week' = week(dd),
  'fy' = floor(quarter(dd, with_year = TRUE, fiscal_start = 11)),
  'q' = quarter(dd, with_year = FALSE, fiscal_start = 11)
  )


df <- df %>% unite("yearmonth",c(year,monthname),sep = "-",remove=FALSE)
df <- df %>% unite("yearq",c(fy,q),sep = "-Q",remove=FALSE)


codes <- data.frame(
  month = c(1,2,3,4,5,6,7,8,9,10,11,12),
  mm = c('01','02','03','04','05','06','07','08','09','10','11','12'))


df <- inner_join(df,codes)

codes <- data.frame(
  day = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
            16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),
  dd = c('01','02','03','04','05','06','07','08','09','10','11','12','13',
         '14','15',
         '16','17','18','19','20','21','22','23','24','25','26','27','28',
         '29','30','31')
)

df <- inner_join(df,codes)

df <- df %>% unite("yyyymmdd",c(year,mm,dd),sep = "",remove=FALSE)
df <- df %>% unite("mmddyyyy",c(mm,dd,year),sep = "/",remove=FALSE)


write.csv(df,"dates.csv",row.names = FALSE)
