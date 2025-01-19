SELECT CAST(MAX("monthly_count") AS DECIMAL(10,4)) AS "Highest_monthly_delivered_orders_volume"
FROM (
    SELECT LEFT("order_delivered_customer_date", 7) AS "year_month", COUNT(*) AS "monthly_count"
    FROM BRAZILIAN_E_COMMERCE.BRAZILIAN_E_COMMERCE."OLIST_ORDERS"
    WHERE "order_status" = 'delivered' 
      AND "order_delivered_customer_date" IS NOT NULL 
      AND LEFT("order_delivered_customer_date", 4) = '2016'
    GROUP BY "year_month"
) AS "monthly_counts";