WITH monthly_total AS (
    SELECT DATE_TRUNC('month', "date") AS sales_month,
           SUM("volume_sold_liters") AS total_volume_liters
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" >= DATEADD(month, -24, CURRENT_DATE)
    GROUP BY sales_month
),
category_monthly_volume AS (
    SELECT DATE_TRUNC('month', "date") AS sales_month,
           "category_name",
           SUM("volume_sold_liters") AS category_volume_liters
    FROM IOWA_LIQUOR_SALES.IOWA_LIQUOR_SALES.SALES
    WHERE "date" >= DATEADD(month, -24, CURRENT_DATE)
    GROUP BY sales_month, "category_name"
),
category_monthly_percentage AS (
    SELECT cm.sales_month,
           cm."category_name",
           (cm.category_volume_liters / mt.total_volume_liters) * 100 AS sales_percentage
    FROM category_monthly_volume cm
    JOIN monthly_total mt ON cm.sales_month = mt.sales_month
),
category_average_percentage AS (
    SELECT "category_name",
           AVG(sales_percentage) AS avg_sales_percentage
    FROM category_monthly_percentage
    GROUP BY "category_name"
),
selected_categories AS (
    SELECT "category_name"
    FROM category_average_percentage
    WHERE avg_sales_percentage >= 1
),
selected_category_data AS (
    SELECT cmp.sales_month,
           cmp."category_name",
           cmp.sales_percentage
    FROM category_monthly_percentage cmp
    JOIN selected_categories sc ON cmp."category_name" = sc."category_name"
),
category_pairs AS (
    SELECT c1."category_name" AS category1,
           c2."category_name" AS category2
    FROM selected_categories c1
    JOIN selected_categories c2
        ON c1."category_name" < c2."category_name"
),
correlations AS (
    SELECT cp.category1,
           cp.category2,
           CORR(sc1.sales_percentage, sc2.sales_percentage) AS correlation_coefficient
    FROM category_pairs cp
    JOIN selected_category_data sc1 ON sc1."category_name" = cp.category1
    JOIN selected_category_data sc2 ON sc2."category_name" = cp.category2 AND sc1.sales_month = sc2.sales_month
    GROUP BY cp.category1, cp.category2
)
SELECT category1 AS Category_1,
       category2 AS Category_2
FROM correlations
ORDER BY correlation_coefficient ASC NULLS LAST
LIMIT 1;