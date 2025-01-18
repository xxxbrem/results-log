SELECT
    T."customer_id",
    COUNT(DISTINCT T."order_id") AS "num_orders",
    ROUND(SUM(T."order_total_payment") / COUNT(DISTINCT T."order_id"), 4) AS "avg_payment_per_order",
    CASE
        WHEN DATEDIFF('day', MIN(T."order_purchase_timestamp"), MAX(T."order_purchase_timestamp")) / 7.0 >= 1.0 THEN
            ROUND(DATEDIFF('day', MIN(T."order_purchase_timestamp"), MAX(T."order_purchase_timestamp")) / 7.0, 4)
        ELSE
            1.0
    END AS "lifespan_in_weeks"
FROM
    (
        SELECT
            O."customer_id",
            O."order_id",
            TO_TIMESTAMP(O."order_purchase_timestamp", 'YYYY-MM-DD HH24:MI:SS') AS "order_purchase_timestamp",
            OP."order_total_payment"
        FROM
            "E_COMMERCE"."E_COMMERCE"."ORDERS" O
        JOIN
            (
                SELECT
                    "order_id",
                    SUM("payment_value") AS "order_total_payment"
                FROM
                    "E_COMMERCE"."E_COMMERCE"."ORDER_PAYMENTS"
                GROUP BY
                    "order_id"
            ) OP
        ON O."order_id" = OP."order_id"
    ) T
GROUP BY
    T."customer_id"
ORDER BY
    "avg_payment_per_order" DESC NULLS LAST
LIMIT 3;