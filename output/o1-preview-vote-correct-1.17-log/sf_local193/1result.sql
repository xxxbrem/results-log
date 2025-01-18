WITH first_payments AS (
  SELECT
    "customer_id",
    MIN(TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS first_payment_ts
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  GROUP BY "customer_id"
),
customer_payments AS (
  SELECT
    p."customer_id",
    p."amount",
    TO_TIMESTAMP(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3') AS payment_ts,
    fp.first_payment_ts
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
  JOIN first_payments fp ON p."customer_id" = fp."customer_id"
),
customer_ltv AS (
  SELECT
    "customer_id",
    SUM("amount") AS total_ltv,
    SUM(
      CASE
        WHEN DATEDIFF('second', first_payment_ts, payment_ts) <= 7 * 86400 THEN "amount"
        ELSE 0
      END
    ) AS amount_in_first_7_days,
    SUM(
      CASE
        WHEN DATEDIFF('second', first_payment_ts, payment_ts) <= 30 * 86400 THEN "amount"
        ELSE 0
      END
    ) AS amount_in_first_30_days
  FROM customer_payments
  GROUP BY "customer_id"
  HAVING SUM("amount") > 0
)
SELECT
  ROUND(AVG(total_ltv), 4) AS "Average_LTV",
  TO_VARCHAR(ROUND(AVG((amount_in_first_7_days / total_ltv) * 100), 4)) || '%' AS "Percentage_in_first_7_days",
  TO_VARCHAR(ROUND(AVG((amount_in_first_30_days / total_ltv) * 100), 4)) || '%' AS "Percentage_in_first_30_days"
FROM customer_ltv;