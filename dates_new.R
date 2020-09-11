# Todd Takala
# 2020-08-31

library(dplyr)
library(lubridate)
library(RODBC)

setwd("C:/Users/9553/git/dates")


newfiscal = 11 # November marks the new fiscal year

df <- data.frame('base_date' = seq(as.Date("1900-01-01"), as.Date("2100-12-31"), "days")) %>%
  mutate(base_datetime = as_datetime(base_date),
         base_month = as.integer(month(base_date)),
         month_name = as.character(month(base_date, label = TRUE)),
         month_2_digit = format(base_date, "%m"),
         base_day = day(base_date),
         base_day_2_digit = format(base_date, "%d"),
         day_of_week = weekdays(base_date),
         base_year = as.integer(year(base_date)),
         iso_date = as.integer(format(base_date, "%Y%m%d")),
         usa_date = format(base_date, "%m/%d/%Y"),
         year_month = format(base_date, "%Y-%m"),
         year_month_name = paste(year(base_date),  month(base_date, label = TRUE), sep = "-"),
         iso_week = as.integer(week(base_date)),
         fiscal_quarter = quarter(base_date, with_year = FALSE, fiscal_start = newfiscal),
         fiscal_year = as.integer(quarter(base_date, with_year = TRUE, fiscal_start = newfiscal)),
         fiscal_year_quarter = paste('FY', as.integer(quarter(base_date, with_year = TRUE, fiscal_start = newfiscal)), '-Q', quarter(base_date, with_year = FALSE, fiscal_start = newfiscal), sep = ""),
         ) %>%
  mutate(
    end_of_day = base_date + hours(23) + minutes(59) + seconds(59),
    first_of_week = floor_date(base_date, 'week'),
    end_of_week = ceiling_date(base_date, 'week') + hours(23) + minutes(59) + seconds(59) - days(1),
    first_of_month = floor_date(base_date, 'month'),
    end_of_month = ceiling_date(base_date, 'month') + hours(23) + minutes(59) + seconds(59) - days(1),
    first_of_year = floor_date(base_date, 'year'),
    end_of_year = ceiling_date(base_date, 'year') + hours(23) + minutes(59) + seconds(59) - days(1),
    past_12_months = floor_date(base_date - months(12), 'month'),
    past_9_months = floor_date(base_date - months(9), 'month'),
    past_6_months = floor_date(base_date - months(6), 'month'),
    past_3_months = floor_date(base_date - months(3), 'month'),
    past_2_months = floor_date(base_date - months(2), 'month'),
    past_1_month = floor_date(base_date - months(1), 'month'),
    end_of_previous_month = floor_date(base_datetime, 'month') + hours(23) + minutes(59) + seconds(59) - days(1),
    first_day_of_quarter = floor_date(base_date, "quarter") + months(1),
    last_day_of_quarter = ceiling_date(base_datetime, "quarter") + months(1)+ hours(23) + minutes(59) + seconds(59) - days(1)
  )

write.csv(df, 'dates.csv',quote = TRUE, eol = "\n")

# df %>% filter(base_date == as.Date('2019-09-10'))
# 
# 
# 
# 
# glimpse(df)
# con <- odbcConnect("9553Dev")
# 
# sqlDrop(con, 'date_reference')
# sqlSave(
#   con,
#   df,
#   tablename = 'date_reference',
#   append = FALSE,
#   rownames = FALSE,
#   colnames = FALSE,
#   verbose = FALSE,
#   safer = TRUE,
#   addPK = FALSE,
#   fast = TRUE,
#   test = FALSE,
#   nastring = NULL,
#   varTypes = c(
#     base_date = 'date',
#     base_month = 'int',
#     month_name = 'varchar(3)',
#     month_2_digit= 'varchar(2)',
#     base_day = 'int',
#     base_day_2_digit = 'varchar(2)',
#     day_of_week = 'varchar(16)',
#     base_year = 'int',
#     iso_date = 'int',
#     usa_date = 'varchar(10)',
#     year_month = 'varchar(7)',
#     year_month_name = 'varchar(8)',
#     iso_week = 'int',
#     fiscal_quarter = 'int',
#     fiscal_year = 'int',
#     fiscal_year_quarter = 'varchar(9)',
#     end_of_day = 'datetime',
#     first_of_week = 'date',
#     end_of_week = 'datetime',
#     end_of_month = 'datetime',
#     first_of_year = 'date',
#     end_of_year = 'datetime',
#     past_12_months = 'date',
#     past_9_months = 'date',
#     past_6_months = 'date',
#     past_3_months = 'date',
#     past_2_months = 'date',
#     past_1_month = 'date',
#     end_of_previous_month = 'datetime',
#     first_day_of_quarter = 'date',
#     last_day_of_quarter = 'datetime'
#   )
# )
# 
# odbcCloseAll()
