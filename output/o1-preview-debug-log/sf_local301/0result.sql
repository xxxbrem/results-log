WITH parsed_sales AS (
    SELECT
        "calendar_year" AS "Year",
        "sales",
        TRY_TO_DATE("week_date_formatted") AS week_date
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.CLEANED_WEEKLY_SALES
    WHERE
        "calendar_year" IN (2018, 2019, 2020)
)
SELECT
    "Year",
    ROUND(SUM(CASE
        WHEN week_date >= DATEADD(day, -28, DATE_FROM_PARTS("Year", 6, 15))
             AND week_date < DATE_FROM_PARTS("Year", 6, 15)
        THEN "sales" ELSE 0 END), 4) AS "Sales_Before_June15",
    ROUND(SUM(CASE
        WHEN week_date >= DATE_FROM_PARTS("Year", 6, 15)
             AND week_date < DATEADD(day, 28, DATE_FROM_PARTS("Year", 6, 15))
        THEN "sales" ELSE 0 END), 4) AS "Sales_After_June15",
    ROUND((
        SUM(CASE
            WHEN week_date >= DATE_FROM_PARTS("Year", 6, 15)
                 AND week_date < DATEADD(day, 28, DATE_FROM_PARTS("Year", 6, 15))
            THEN "sales" ELSE 0 END)
        - SUM(CASE
            WHEN week_date >= DATEADD(day, -28, DATE_FROM_PARTS("Year", 6, 15))
                 AND week_date < DATE_FROM_PARTS("Year", 6, 15)
            THEN "sales" ELSE 0 END)
        )
        / NULLIF(CAST(SUM(CASE
            WHEN week_date >= DATEADD(day, -28, DATE_FROM_PARTS("Year", 6, 15))
                 AND week_date < DATE_FROM_PARTS("Year", 6, 15)
            THEN "sales" ELSE 0 END) AS FLOAT), 0)
        * 100
    , 4) AS "Percentage_Change"
FROM
    parsed_sales
GROUP BY
    "Year"
ORDER BY
    "Year";