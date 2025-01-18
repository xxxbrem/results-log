SELECT
  "Year",
  "Sales_Before_June_15",
  "Sales_After_June_15",
  ROUND((("Sales_After_June_15" - "Sales_Before_June_15") / "Sales_Before_June_15") * 100, 4) AS "Percentage_Change"
FROM
(
  SELECT
    '2018' AS "Year",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2018-05-21' AND '2018-06-11' THEN "sales" ELSE 0 END) AS "Sales_Before_June_15",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2018-06-18' AND '2018-07-09' THEN "sales" ELSE 0 END) AS "Sales_After_June_15"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
  WHERE "calendar_year" = 2018

  UNION ALL

  SELECT
    '2019' AS "Year",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2019-05-20' AND '2019-06-10' THEN "sales" ELSE 0 END) AS "Sales_Before_June_15",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2019-06-17' AND '2019-07-08' THEN "sales" ELSE 0 END) AS "Sales_After_June_15"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
  WHERE "calendar_year" = 2019

  UNION ALL

  SELECT
    '2020' AS "Year",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2020-05-18' AND '2020-06-08' THEN "sales" ELSE 0 END) AS "Sales_Before_June_15",
    SUM(CASE WHEN CAST("week_date_formatted" AS DATE) BETWEEN '2020-06-15' AND '2020-07-06' THEN "sales" ELSE 0 END) AS "Sales_After_June_15"
  FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
  WHERE "calendar_year" = 2020
) AS T;