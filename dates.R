
library(timeDate)
library(tidyr)
library(dplyr)
library(RODBC)
library(zoo)
library(lubridate)

# setwd("~/git/dates")
setwd("E:/git/dates")


st <- as.Date("1900-01-01")
en <- as.Date("2099-12-31")


# New Fiscal Year 11/1
newfiscal = 11


getMonth <- function(i) {
  mymonths <- c("Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec")
  return(mymonths[i])
}


dd <- ymd(seq(en, st, by = "-1 day"))

v1 <- as.character(seq(from = 1, to = length(dd)))


df <- data.frame(
  'date' = dd,
  'month' = month(dd),
  'monthname' = getMonth(month(dd)),
  'day' = day(dd),
  'year' = year(dd),
  'fod' = as_datetime(floor_date(dd, "day")),
  'eod' = dd + hours(24) - seconds(0.1),
  'fow' = as_datetime(floor_date(dd, "week")),
  'eow' = as_datetime(ceiling_date(dd, "week")) - seconds(0.1),
  'fom' = as_datetime(floor_date(dd, "month")),
  'eom' = ymd_hms(timeLastDayInMonth(dd) + hours(24) - seconds(0.1)),
  'dow' = weekdays(dd),
  'isoweek' = week(dd),
  'q' = quarter(dd, with_year = FALSE, fiscal_start = newfiscal),
  'yearq' = quarter(dd, with_year = TRUE, fiscal_start = newfiscal),
  'fy' = as.integer(quarter(dd, with_year = TRUE, fiscal_start = newfiscal))
)






df <-
  df %>% unite("yearmonth",
               c(year, monthname),
               sep = "-",
               remove = FALSE)
# df <- df %>% unite("yearq", c(fy, q), sep = "-Q", remove = FALSE)


codes <- data.frame(
  month = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
  mm = c(
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  )
)


df <- inner_join(df,codes)

codes <- data.frame(
  day = c(
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ),
  dd = c(
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31'
  )
)

df <- inner_join(df, codes)
df <- df %>% unite("yyyymmdd", c(year, mm, dd), sep = "", remove = FALSE)
df <- df %>% unite("mmddyyyy", c(mm, dd, year), sep = "/", remove = FALSE)
df <- df %>% unite("yyyymm", c(year, mm), sep = "-", remove = FALSE)





# write.csv(df,"dates.csv",row.names = FALSE)




con <- odbcConnect("9553Dev")
# con <- odbcConnect("9553Production")

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



