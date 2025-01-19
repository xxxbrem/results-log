WITH finished_orders AS (
    SELECT s."hub_id", o."order_created_month", COUNT(*) AS "order_count"
    FROM DELIVERY_CENTER.DELIVERY_CENTER.ORDERS o
    JOIN DELIVERY_CENTER.DELIVERY_CENTER.STORES s ON o."store_id" = s."store_id"
    WHERE o."order_status" = 'FINISHED'
      AND o."order_created_month" IN (2, 3)
    GROUP BY s."hub_id", o."order_created_month"
),
feb_counts AS (
    SELECT "hub_id", "order_count" AS "feb_count"
    FROM finished_orders
    WHERE "order_created_month" = 2
),
mar_counts AS (
    SELECT "hub_id", "order_count" AS "mar_count"
    FROM finished_orders
    WHERE "order_created_month" = 3
),
order_counts AS (
    SELECT COALESCE(feb."hub_id", mar."hub_id") AS "hub_id",
           feb."feb_count",
           mar."mar_count"
    FROM feb_counts feb
    FULL OUTER JOIN mar_counts mar ON feb."hub_id" = mar."hub_id"
),
percentage_increase AS (
    SELECT
        oc."hub_id",
        oc."feb_count",
        oc."mar_count",
        ((CAST(oc."mar_count" AS FLOAT) - CAST(oc."feb_count" AS FLOAT)) / NULLIF(CAST(oc."feb_count" AS FLOAT), 0)) * 100 AS "percentage_increase"
    FROM order_counts oc
    WHERE oc."feb_count" > 0
)
SELECT
    h."hub_id",
    h."hub_name",
    ROUND(pi."percentage_increase", 4) AS "percentage_increase"
FROM percentage_increase pi
JOIN DELIVERY_CENTER.DELIVERY_CENTER.HUBS h ON pi."hub_id" = h."hub_id"
WHERE pi."percentage_increase" > 20
ORDER BY pi."percentage_increase" DESC NULLS LAST;