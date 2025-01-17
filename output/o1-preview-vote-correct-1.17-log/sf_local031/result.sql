SELECT 
    '2016' AS "Year",
    "month",
    "monthly_volume" AS "Delivered_Orders_Volume"
FROM (
    SELECT 
        SUBSTRING("order_delivered_customer_date", 6, 2) AS "month", 
        COUNT("order_id") AS "monthly_volume"
    FROM 
        "BRAZILIAN_E_COMMERCE"."BRAZILIAN_E_COMMERCE"."OLIST_ORDERS"
    WHERE 
        "order_status" = 'delivered'
        AND "order_delivered_customer_date" IS NOT NULL
        AND SUBSTRING("order_delivered_customer_date", 1, 4) = '2016'
    GROUP BY 
        "month"
) AS monthly_volumes
ORDER BY 
    "monthly_volume" DESC NULLS LAST
LIMIT 1;