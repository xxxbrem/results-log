SELECT
    dd."driver_id",
    dr."driver_modal",
    dr."driver_type",
    ROUND(AVG(dd.deliveries_per_day), 4) AS average_daily_deliveries
FROM (
    SELECT
        d."driver_id",
        SUBSTRING(o."order_moment_delivered", 1, 10) AS delivery_date,
        COUNT(*) AS deliveries_per_day
    FROM DELIVERY_CENTER.DELIVERY_CENTER.DELIVERIES d
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
        ON d."delivery_order_id" = o."order_id"
    WHERE
        d."driver_id" IS NOT NULL
        AND o."order_moment_delivered" IS NOT NULL
        AND d."delivery_status" = 'DELIVERED'
    GROUP BY
        d."driver_id",
        delivery_date
) dd
JOIN DELIVERY_CENTER.DELIVERY_CENTER.DRIVERS dr
    ON dd."driver_id" = dr."driver_id"
GROUP BY
    dd."driver_id",
    dr."driver_modal",
    dr."driver_type"
ORDER BY
    average_daily_deliveries DESC NULLS LAST
LIMIT 5;