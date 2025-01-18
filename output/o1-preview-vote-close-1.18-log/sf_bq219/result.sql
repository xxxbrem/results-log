WITH months AS (
    SELECT DATEADD(month, - (ROW_NUMBER() OVER (ORDER BY seq4()) - 1), DATE_TRUNC('month', (SELECT MAX("date") FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES))) AS "month"
    FROM TABLE(GENERATOR(ROWCOUNT => 24))
),
total_volume AS (
    SELECT m."month", SUM(s."volume_sold_liters") AS "total_volume"
    FROM months m
    LEFT JOIN IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES s ON DATE_TRUNC('month', s."date") = m."month"
    GROUP BY m."month"
),
category_volume AS (
    SELECT m."month", s."category", SUM(s."volume_sold_liters") AS "category_volume"
    FROM months m
    LEFT JOIN IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES s ON DATE_TRUNC('month', s."date") = m."month"
    GROUP BY m."month", s."category"
),
monthly_percentages AS (
    SELECT cv."month", cv."category", cv."category_volume" / tv."total_volume" AS "percentage"
    FROM category_volume cv
    JOIN total_volume tv ON cv."month" = tv."month"
),
category_avg_percentage AS (
    SELECT "category", AVG("percentage") AS "avg_percentage"
    FROM monthly_percentages
    GROUP BY "category"
    HAVING AVG("percentage") >= 0.01
),
categories AS (
    SELECT DISTINCT "category"
    FROM category_avg_percentage
),
full_category_months AS (
    SELECT m."month", c."category"
    FROM months m
    CROSS JOIN categories c
),
filled_monthly_percentages AS (
    SELECT fcm."month", fcm."category", 
        COALESCE(mp."percentage", 0) AS "percentage"
    FROM full_category_months fcm
    LEFT JOIN monthly_percentages mp 
        ON fcm."month" = mp."month" AND fcm."category" = mp."category"
),
category_pairs AS (
    SELECT c1."category" AS "category1", c2."category" AS "category2"
    FROM categories c1
    JOIN categories c2 ON c1."category" < c2."category"
),
correlations AS (
    SELECT cp."category1", cp."category2", 
        ROUND(CORR(fp1."percentage", fp2."percentage"), 4) AS "correlation"
    FROM category_pairs cp
    JOIN filled_monthly_percentages fp1 ON fp1."category" = cp."category1"
    JOIN filled_monthly_percentages fp2 ON fp2."category" = cp."category2" AND fp1."month" = fp2."month"
    GROUP BY cp."category1", cp."category2"
),
result AS (
    SELECT "category1", "category2", "correlation"
    FROM correlations
    ORDER BY "correlation" ASC NULLS LAST
    LIMIT 1
)
SELECT *
FROM result;