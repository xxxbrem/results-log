SELECT
    LPAD(MONTH(date_delivered), 2, '0') AS "Month_num",
    TO_CHAR(date_delivered, 'Month') AS "Month",
    SUM(CASE WHEN YEAR(date_delivered) = 2016 THEN 1 ELSE 0 END) AS "2016_delivered_orders",
    SUM(CASE WHEN YEAR(date_delivered) = 2017 THEN 1 ELSE 0 END) AS "2017_delivered_orders",
    SUM(CASE WHEN YEAR(date_delivered) = 2018 THEN 1 ELSE 0 END) AS "2018_delivered_orders"
FROM (
    SELECT
        TRY_TO_TIMESTAMP(NULLIF("order_delivered_customer_date", ''), 'YYYY-MM-DD HH24:MI:SS') AS date_delivered
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
    WHERE
        "order_status" = 'delivered' AND
        "order_delivered_customer_date" IS NOT NULL AND
        "order_delivered_customer_date" != ''
) sub
WHERE date_delivered IS NOT NULL
GROUP BY
    LPAD(MONTH(date_delivered), 2, '0'),
    TO_CHAR(date_delivered, 'Month')
ORDER BY "Month_num";