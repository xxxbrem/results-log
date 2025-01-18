WITH
-- Compute max date
max_date AS (
    SELECT MAX("date") AS "max_date" FROM "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES"
),
-- Compute start date 24 months before max_date
date_range AS (
    SELECT DATEADD(month, -24, "max_date") AS "start_date", "max_date"
    FROM max_date
),
-- Compute total monthly sales volumes over the past 24 months
monthly_totals AS (
    SELECT
        DATE_TRUNC('month', s."date") AS "month",
        SUM(s."bottles_sold") AS "total_bottles_sold"
    FROM
        "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES" s
        CROSS JOIN date_range dr
    WHERE
        s."date" >= dr."start_date" AND s."date" <= dr."max_date"
    GROUP BY
        "month"
),
-- Compute monthly sales per category over past 24 months
category_monthly_sales AS (
    SELECT
        DATE_TRUNC('month', s."date") AS "month",
        s."category",
        SUM(s."bottles_sold") AS "bottles_sold"
    FROM
        "IOWA_LIQUOR_SALES"."IOWA_LIQUOR_SALES"."SALES" s
        CROSS JOIN date_range dr
    WHERE
        s."date" >= dr."start_date" AND s."date" <= dr."max_date"
    GROUP BY
        "month", s."category"
),
-- Compute percentage contribution per category per month
category_percentage AS (
    SELECT
        cms."month",
        cms."category",
        cms."bottles_sold",
        mt."total_bottles_sold",
        (cms."bottles_sold" * 100.0) / mt."total_bottles_sold" AS "percentage_contribution"
    FROM
        category_monthly_sales cms
        JOIN monthly_totals mt ON cms."month" = mt."month"
),
-- Compute average percentage contribution per category over 24 months
category_avg_percentage AS (
    SELECT
        "category",
        AVG("percentage_contribution") AS "avg_percentage_contribution"
    FROM
        category_percentage
    GROUP BY
        "category"
    HAVING
        AVG("percentage_contribution") >= 1.0
),
-- Get selected categories' monthly percentage contributions
selected_category_percentage AS (
    SELECT cp.*
    FROM category_percentage cp
    JOIN category_avg_percentage cap ON cp."category" = cap."category"
),
-- Get percentage contributions for category pairs per month
category_pair_percentages AS (
    SELECT
        cp1."category" AS "category1",
        cp2."category" AS "category2",
        cp1."month",
        cp1."percentage_contribution" AS "percentage1",
        cp2."percentage_contribution" AS "percentage2"
    FROM
        selected_category_percentage cp1
        JOIN selected_category_percentage cp2
            ON cp1."month" = cp2."month"
            AND cp1."category" < cp2."category"
),
-- Compute correlation coefficients for each pair
pair_correlations AS (
    SELECT
        cpp."category1",
        cpp."category2",
        CORR(cpp."percentage1", cpp."percentage2") AS "correlation_coefficient"
    FROM
        category_pair_percentages cpp
    GROUP BY
        cpp."category1",
        cpp."category2"
)
-- Final query: select the pair with the lowest correlation, rounded to four decimal places
SELECT
    pc."category1",
    pc."category2",
    ROUND(pc."correlation_coefficient", 4) AS "correlation_coefficient"
FROM
    pair_correlations pc
ORDER BY
    pc."correlation_coefficient" ASC NULLS LAST
LIMIT 1;