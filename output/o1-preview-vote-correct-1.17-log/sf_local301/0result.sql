WITH sales_data AS (
    SELECT
        "calendar_year",
        TO_DATE("week_date_formatted", 'YYYY-MM-DD') AS week_date,
        "sales"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
    WHERE "calendar_year" IN (2018, 2019, 2020)
),
weeks_before_after AS (
    SELECT
        "calendar_year",
        CASE
            WHEN week_date >= DATE_FROM_PARTS("calendar_year", 5, 18) AND week_date < DATE_FROM_PARTS("calendar_year", 6, 15) THEN 'Before'
            WHEN week_date >= DATE_FROM_PARTS("calendar_year", 6, 15) AND week_date <= DATE_FROM_PARTS("calendar_year", 7, 12) THEN 'After'
            ELSE NULL
        END AS period,
        "sales"
    FROM sales_data
),
sales_summary AS (
    SELECT
        "calendar_year",
        period,
        SUM("sales") AS total_sales
    FROM weeks_before_after
    WHERE period IS NOT NULL
    GROUP BY "calendar_year", period
)
SELECT
    s_before."calendar_year" AS "Year",
    ROUND(((s_after.total_sales - s_before.total_sales) / s_before.total_sales) * 100, 4) AS "Percentage_Change"
FROM
    (SELECT * FROM sales_summary WHERE period = 'Before') s_before
JOIN
    (SELECT * FROM sales_summary WHERE period = 'After') s_after
    ON s_before."calendar_year" = s_after."calendar_year";