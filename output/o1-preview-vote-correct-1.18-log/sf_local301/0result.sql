SELECT
  "Year",
  "Sales_Before",
  "Sales_After",
  ROUND((("Sales_After" - "Sales_Before") / "Sales_Before") * 100, 4) AS "Percentage_Change"
FROM
  (
    SELECT
      "calendar_year" AS "Year",
      SUM(CASE WHEN "week_date_converted" >= DATEADD(week, -4, DATE_TRUNC('week', TO_DATE(CONCAT("calendar_year", '-06-15'))))
               AND "week_date_converted" < DATE_TRUNC('week', TO_DATE(CONCAT("calendar_year", '-06-15')))
               THEN "sales" ELSE 0 END) AS "Sales_Before",
      SUM(CASE WHEN "week_date_converted" >= DATE_TRUNC('week', TO_DATE(CONCAT("calendar_year", '-06-15')))
               AND "week_date_converted" < DATEADD(week, 4, DATE_TRUNC('week', TO_DATE(CONCAT("calendar_year", '-06-15'))))
               THEN "sales" ELSE 0 END) AS "Sales_After"
    FROM
      (
        SELECT
          "calendar_year",
          TRY_TO_DATE("week_date", 'YYYY-MM-DD') AS "week_date_converted",
          "sales"
        FROM
          "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
        WHERE
          "calendar_year" IN (2018, 2019, 2020)
      ) AS sub
    GROUP BY
      "calendar_year"
  )
ORDER BY
  "Year";