SELECT
    TO_CHAR(DATE_FROM_PARTS(2000, "Month_Number", 1), 'Mon') AS "Month",
    SUM(CASE WHEN "Year" = 2016 THEN "order_count" ELSE 0 END) AS "2016",
    SUM(CASE WHEN "Year" = 2017 THEN "order_count" ELSE 0 END) AS "2017",
    SUM(CASE WHEN "Year" = 2018 THEN "order_count" ELSE 0 END) AS "2018"
FROM (
    SELECT
        EXTRACT(MONTH FROM TO_DATE(SUBSTR("order_delivered_customer_date", 1, 10), 'YYYY-MM-DD')) AS "Month_Number",
        EXTRACT(YEAR FROM TO_DATE(SUBSTR("order_delivered_customer_date", 1, 10), 'YYYY-MM-DD')) AS "Year",
        COUNT(*) AS "order_count"
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE.OLIST_ORDERS
    WHERE
        "order_status" = 'delivered'
        AND "order_delivered_customer_date" IS NOT NULL
        AND "order_delivered_customer_date" != ''
    GROUP BY
        EXTRACT(MONTH FROM TO_DATE(SUBSTR("order_delivered_customer_date", 1, 10), 'YYYY-MM-DD')),
        EXTRACT(YEAR FROM TO_DATE(SUBSTR("order_delivered_customer_date", 1, 10), 'YYYY-MM-DD'))
) AS sub
GROUP BY
    "Month_Number"
ORDER BY
    "Month_Number";