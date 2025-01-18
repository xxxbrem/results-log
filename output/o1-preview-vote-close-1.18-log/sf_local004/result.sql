SELECT
    O."customer_id",
    COUNT(DISTINCT O."order_id") AS "num_orders",
    ROUND(SUM(P."total_payment_per_order") / COUNT(DISTINCT O."order_id"), 4) AS "avg_payment_per_order",
    ROUND(
        GREATEST(
            DATEDIFF(
                'day',
                MIN(TO_TIMESTAMP(O."order_purchase_timestamp", 'YYYY-MM-DD HH24:MI:SS')),
                MAX(TO_TIMESTAMP(O."order_purchase_timestamp", 'YYYY-MM-DD HH24:MI:SS'))
            ) / 7.0,
            1.0
        ),
        4
    ) AS "customer_lifespan_weeks"
FROM
    E_COMMERCE.E_COMMERCE."ORDERS" O
JOIN
    (
        SELECT
            OP."order_id",
            SUM(OP."payment_value") AS "total_payment_per_order"
        FROM
            E_COMMERCE.E_COMMERCE."ORDER_PAYMENTS" OP
        GROUP BY
            OP."order_id"
    ) P
ON
    O."order_id" = P."order_id"
GROUP BY
    O."customer_id"
ORDER BY
    "avg_payment_per_order" DESC NULLS LAST
LIMIT 3;