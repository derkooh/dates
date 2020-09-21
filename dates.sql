SELECT base_date, 
       CONVERT(VARCHAR, base_date, 101) AS us_date, 
       CONVERT(VARCHAR(10), base_date, 112) AS iso_date, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, base_date))) AS base_date_end, 
       YEAR(base_date) AS base_year, 
       MONTH(base_date) AS base_month, 
       LEFT(CONVERT(CHAR(20), base_date, 101), 2) AS base_month_2_digit, 
       LEFT(CONVERT(VARCHAR(10), base_date, 112), 4) + '-' + SUBSTRING(CONVERT(VARCHAR(10), base_date, 112), 5, 2) AS year_month, 
       LEFT(CONVERT(VARCHAR(10), base_date, 112), 4) + '-' + LEFT(UPPER(DateName(month, DATEADD(month, MONTH(base_date), -1))), 3) AS year_month_name, 
       UPPER(DateName(month, DATEADD(month, MONTH(base_date), -1))) AS base_month_name, 
       LEFT(UPPER(DateName(month, DATEADD(month, MONTH(base_date), -1))), 3) AS base_month_name_short, 
       UPPER(DATENAME(week, base_date)) AS iso_week, 
       DAY(base_date) AS base_day, 
       SUBSTRING(CONVERT(CHAR(20), base_date, 101), 4, 2) AS base_day_2_digit,
       UPPER(DATENAME(weekday, base_date)) AS day_of_week,
       CASE MONTH(base_date)
           WHEN 11
           THEN CAST(YEAR(base_date) + 1 AS NVARCHAR)
           WHEN 12
           THEN CAST(YEAR(base_date) + 1 AS NVARCHAR)
           WHEN 1
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 2
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 3
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 4
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 5
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 6
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 7
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 8
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 9
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           WHEN 10
           THEN CAST(YEAR(base_date) AS NVARCHAR)
           ELSE 'ERROR!'
       END fiscal_year,
       CASE MONTH(base_date)
           WHEN 11
           THEN 'Q1'
           WHEN 12
           THEN 'Q1'
           WHEN 1
           THEN 'Q1'
           WHEN 2
           THEN 'Q2'
           WHEN 3
           THEN 'Q2'
           WHEN 4
           THEN 'Q2'
           WHEN 5
           THEN 'Q3'
           WHEN 6
           THEN 'Q3'
           WHEN 7
           THEN 'Q3'
           WHEN 8
           THEN 'Q4'
           WHEN 9
           THEN 'Q4'
           WHEN 10
           THEN 'Q4'
           ELSE 'ERROR!'
       END fiscal_quarter,
       CASE MONTH(base_date)
           WHEN 11
           THEN CAST(YEAR(base_date) + 1 AS NVARCHAR) + '-Q1'
           WHEN 12
           THEN CAST(YEAR(base_date) + 1 AS NVARCHAR) + '-Q1'
           WHEN 1
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q1'
           WHEN 2
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q2'
           WHEN 3
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q2'
           WHEN 4
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q2'
           WHEN 5
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q3'
           WHEN 6
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q3'
           WHEN 7
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q3'
           WHEN 8
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q4'
           WHEN 9
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q4'
           WHEN 10
           THEN CAST(YEAR(base_date) AS NVARCHAR) + '-Q4'
           ELSE 'ERROR!'
       END fy_quarter,
	   
	   CASE MONTH(base_date)
           WHEN 11
           THEN 'FALL'
           WHEN 12
           THEN 'WINTER'
           WHEN 1
           THEN 'WINTER'
           WHEN 2
           THEN 'WINTER'
           WHEN 3
           THEN 'SPRING'
           WHEN 4
           THEN 'SPRING'
           WHEN 5
           THEN 'SPRING'
           WHEN 6
           THEN 'SUMMER'
           WHEN 7
           THEN 'SUMMER'
           WHEN 8
           THEN 'SUMMER'
           WHEN 9
           THEN 'FALL'
           WHEN 10
           THEN 'FALL'
           ELSE 'ERROR!'
       END season,


       CAST(DATEADD(week, DATEDIFF(week, 0, base_date), 0) AS DATE) AS start_of_week, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, DATEADD(week, DATEDIFF(week, 0, base_date), 6)))) AS end_of_week, 
       CAST(DATEADD(month, DATEDIFF(month, 0, base_date), 0) AS DATE) AS start_of_month, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(base_date)))) AS end_of_month, 
       DATEFROMPARTS(YEAR(base_date), 1, 1) AS first_of_year, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 12, 31))))) AS end_of_year, 
       DATEFROMPARTS(YEAR(base_date), 11, 1) AS first_of_fiscal, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 10, 31))))) AS end_of_fiscal, 
       DATEFROMPARTS(YEAR(base_date), 11, 1) AS first_of_q1, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 1, 31))))) AS end_of_q1, 
       DATEFROMPARTS(YEAR(base_date), 2, 1) AS first_of_q2, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 4, 30))))) AS end_of_q2, 
       DATEFROMPARTS(YEAR(base_date), 5, 1) AS first_of_q3, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 7, 31))))) AS end_of_q3, 
       DATEFROMPARTS(YEAR(base_date), 8, 1) AS first_of_q4, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, EOMONTH(DATEFROMPARTS(YEAR(base_date), 10, 31))))) AS end_of_q4, 
       CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, base_date) - 1, 0) AS DATE) AS first_of_previous_month, 
       DATEADD(ns, -100, DATEADD(D, 1, CONVERT(DATETIME2, DATEADD(MONTH, DATEDIFF(MONTH, -1, base_date) - 1, -1)))) AS end_of_previous_month, 
       CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, base_date) - 12, 0) AS DATE) AS first_of_previous_year, 
       CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, base_date) - 6, 0) AS DATE) AS first_of_prev_6_months, 
       CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, base_date) - 3, 0) AS DATE) AS first_of_prev_3_months, 
       CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, base_date) - 2, 0) AS DATE) AS first_of_prev_2_months
INTO date_reference
FROM date_ref
ORDER BY base_date DESC;