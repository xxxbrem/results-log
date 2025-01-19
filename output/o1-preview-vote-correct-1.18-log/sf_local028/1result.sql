WITH months AS (
    SELECT '01' AS "Month_num", 'Jan' AS "Month"
    UNION ALL SELECT '02', 'Feb'
    UNION ALL SELECT '03', 'Mar'
    UNION ALL SELECT '04', 'Apr'
    UNION ALL SELECT '05', 'May'
    UNION ALL SELECT '06', 'Jun'
    UNION ALL SELECT '07', 'Jul'
    UNION ALL SELECT '08', 'Aug'
    UNION ALL SELECT '09', 'Sep'
    UNION ALL SELECT '10', 'Oct'
    UNION ALL SELECT '11', 'Nov'
    UNION ALL SELECT '12', 'Dec'
),
orders_by_month_year AS (
    SELECT
        LPAD(CAST(EXTRACT(MONTH FROM TRY_TO_TIMESTAMP_NTZ("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS VARCHAR), 2, '0') AS "Month_num",
        EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) AS "Year",
        COUNT(*) AS "num_orders"
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
    WHERE "order_status" = 'delivered'
        AND "order_delivered_customer_date" IS NOT NULL
        AND TRY_TO_TIMESTAMP_NTZ("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
        AND EXTRACT(YEAR FROM TRY_TO_TIMESTAMP_NTZ("order_delivered_customer_date", 'YYYY-MM-DD HH24:MI:SS')) IN (2016, 2017, 2018)
    GROUP BY 1, 2
)
SELECT
    m."Month_num",
    m."Month",
    COALESCE(SUM(CASE WHEN o."Year" = 2016 THEN o."num_orders" END), 0) AS "2016",
    COALESCE(SUM(CASE WHEN o."Year" = 2017 THEN o."num_orders" END), 0) AS "2017",
    COALESCE(SUM(CASE WHEN o."Year" = 2018 THEN o."num_orders" END), 0) AS "2018"
FROM months m
LEFT JOIN orders_by_month_year o
    ON m."Month_num" = o."Month_num"
GROUP BY m."Month_num", m."Month"
ORDER BY m."Month_num";