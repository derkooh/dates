# Todd Takala
# 2020-06-19

library(timeDate)
library(tidyr)
library(dplyr)
library(RODBC)
library(zoo)
library(lubridate)

setwd("~/git/dates")
# setwd("c:/Users/9953/git/dates")

newfiscal = 11 # November

dd <- seq(as.Date("1900-01-01"), as.Date("2099-12-31"), "days")

df <- data.frame(
  'date' = dd,
  'month' = month(dd),
  'monthname' = month(dd, label = TRUE),
  'mm' = format(dd, "%m"),
  'day' = day(dd),
  'dd' = format(dd, "%d"),
  'year' = year(dd),
  'fod' = as_datetime(floor_date(dd, "day")),
  'eod' = dd + hours(24) - seconds(0.001),
  'fow' = as_datetime(floor_date(dd, "week")),
  'eow' = as_datetime(ceiling_date(dd, "week")) - seconds(0.001),
  'fom' = as_datetime(floor_date(dd, "month")),
  'eom' = ymd_hms(timeLastDayInMonth(dd) + hours(24) - seconds(0.001)),
  'dow' = weekdays(dd),
  'isoweek' = week(dd),
  'q' = quarter(dd, with_year = FALSE, fiscal_start = newfiscal),
  'yearq' = quarter(dd, with_year = TRUE, fiscal_start = newfiscal),
  'fy' = as.integer(quarter(
    dd, with_year = TRUE, fiscal_start = newfiscal
  ))
) %>% unite("yearmonth",
            c(year, monthname),
            sep = "-",
            remove = FALSE) %>%
  unite("yyyymmdd", c(year, mm, dd), sep = "", remove = FALSE) %>%
  unite("mmddyyyy", c(mm, dd, year), sep = "/", remove = FALSE) %>%
  unite("yyyymm", c(year, mm), sep = "-", remove = FALSE)


# write.csv(df,"dates.csv",row.names = FALSE)


# con <- odbcConnect("9553Dev")
con <- odbcConnect("9553Production")
# con <- odbcDriverConnect(
#   "driver={SQL Server};server=vsqlcorp;database=Technical;trusted_connection=true'")

sqlDrop(con, 'Dates')
sqlSave(
  con,
  df,
  tablename = 'Dates',
  append = FALSE,
  rownames = FALSE,
  colnames = FALSE,
  verbose = FALSE,
  safer = TRUE,
  addPK = FALSE,
  fast = TRUE,
  test = FALSE,
  nastring = NULL,
  varTypes = c(
    date = 'date',
    month = 'int',
    yearmonth = 'varchar(8)',
    monthname = 'varchar(3)',
    day = 'int',
    yyyymmdd = 'int',
    mmddyyyy = 'varchar(10)',
    yyyymm = 'varchar(7)',
    year = 'int',
    fod = 'datetime',
    eod = 'datetime',
    fow = 'datetime',
    eow = 'datetime',
    fom = 'datetime',
    eom = 'datetime',
    dow = 'varchar(12)',
    isoweek = 'int',
    yearq = 'decimal(5,1)',
    fy = 'int',
    q = 'int',
    mm = 'varchar(2)',
    dd = 'varchar(2)'
  )
)

odbcCloseAll()

