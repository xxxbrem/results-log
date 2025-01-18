WITH deliveries_per_day AS (
    SELECT
        d."driver_id",
        o."order_created_year",
        o."order_created_month",
        o."order_created_day",
        COUNT(*) AS daily_deliveries
    FROM
        DELIVERY_CENTER.DELIVERY_CENTER.DELIVERIES d
        JOIN DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
            ON d."delivery_order_id" = o."delivery_order_id"
    WHERE
        d."driver_id" IS NOT NULL
    GROUP BY
        d."driver_id",
        o."order_created_year",
        o."order_created_month",
        o."order_created_day"
),
average_deliveries AS (
    SELECT
        dpd."driver_id",
        AVG(dpd.daily_deliveries) AS "average_daily_deliveries"
    FROM
        deliveries_per_day dpd
    GROUP BY
        dpd."driver_id"
),
top_drivers AS (
    SELECT
        ad."driver_id",
        dr."driver_modal",
        dr."driver_type",
        ad."average_daily_deliveries"
    FROM
        average_deliveries ad
        JOIN DELIVERY_CENTER.DELIVERY_CENTER.DRIVERS dr
            ON ad."driver_id" = dr."driver_id"
        ORDER BY
            ad."average_daily_deliveries" DESC NULLS LAST
        LIMIT 5
)
SELECT
    td."driver_id",
    td."driver_modal",
    td."driver_type",
    ROUND(td."average_daily_deliveries", 4) AS "average_daily_deliveries"
FROM
    top_drivers td;