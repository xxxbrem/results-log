WITH sales_data AS (
    SELECT 
        "calendar_year",
        TO_DATE("week_date", 'YYYY-MM-DD') AS "week_start_date",
        "sales"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."CLEANED_WEEKLY_SALES"
    WHERE
        "calendar_year" IN (2018, 2019, 2020)
),
dates AS (
    SELECT
        "calendar_year",
        TO_DATE(CONCAT("calendar_year", '-06-15'), 'YYYY-MM-DD') AS "june15",
        DATEADD('day', -28, TO_DATE(CONCAT("calendar_year", '-06-15'), 'YYYY-MM-DD')) AS "date_before",
        DATEADD('day', 27, TO_DATE(CONCAT("calendar_year", '-06-15'), 'YYYY-MM-DD')) AS "date_after"
    FROM
        (SELECT DISTINCT "calendar_year" FROM sales_data)
),
sales_before AS (
    SELECT
        s."calendar_year",
        SUM(s."sales") AS "total_sales_before"
    FROM
        sales_data s
        JOIN dates d ON s."calendar_year" = d."calendar_year"
    WHERE
        s."week_start_date" BETWEEN d."date_before" AND DATEADD('day', -1, d."june15")
    GROUP BY
        s."calendar_year"
),
sales_after AS (
    SELECT
        s."calendar_year",
        SUM(s."sales") AS "total_sales_after"
    FROM
        sales_data s
        JOIN dates d ON s."calendar_year" = d."calendar_year"
    WHERE
        s."week_start_date" BETWEEN d."june15" AND d."date_after"
    GROUP BY
        s."calendar_year"
)
SELECT
    s_before."calendar_year" AS "Year",
    ROUND(((s_after."total_sales_after" - s_before."total_sales_before") / s_before."total_sales_before") * 100, 4) AS "Percentage_Change_in_Sales"
FROM
    sales_before s_before
    JOIN sales_after s_after ON s_before."calendar_year" = s_after."calendar_year"
ORDER BY
    "Year";