# Todd Takala
# 2020-06-19

library(dplyr)
library(lubridate)
library(RODBC)

newfiscal = 11 # November marks the new fiscal year
dd <- seq(as.Date("1900-01-01"), as.Date("2050-12-31"), "days")
dt <- as_datetime(dd)

df <- data.frame(
  'date' = dd,
  'month' = month(dd),
  'monthname' = month(dd, label = TRUE),
  'mm' = format(dd, "%m"),
  'day' = day(dd),
  'dd' = format(dd, "%d"),
  'year' = year(dd),
  'yyyymmdd' = format(dd, "%Y%m%d"),
  'mmddyyyy' = format(dd, "%m/%d/%Y"),
  'yyyymm' = format(dd, "%Y-%m"),
  'fod' = floor_date(dt, "day"),
  'eod' = ceiling_date(dt, "day") - seconds(1),
  'fow' = floor_date(dt, "week"),
  'eow' = ceiling_date(dt, "week") - seconds(1),
  'fom' = floor_date(dt, "month"),
  'eom' = ceiling_date(dt, "month") - seconds(1),
  'foy' = floor_date(dt, "year"),
  'eoy' = ceiling_date(dt, "year") - seconds(1),
  'dow' = weekdays(dd),
  'isoweek' = week(dd),
  'q' = quarter(dd, with_year = FALSE, fiscal_start = newfiscal),
  'yearq' = quarter(dd, with_year = TRUE, fiscal_start = newfiscal),
  'fy' = as.integer(quarter(dd, with_year = TRUE, fiscal_start = newfiscal))
) %>% mutate(yearmonth = paste(year, monthname,sep="-"))

################################################################################

# con <- odbcConnect("9553Dev")
con <- odbcConnect("9553Production")
# con <- odbcDriverConnect(
#   "driver={SQL Server};\n
#    server=vsqlcorp;\n
#    database=Technical;\n
#    trusted_connection=true'")

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
    foy = 'datetime',
    eoy = 'datetime',
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
