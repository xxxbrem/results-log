SELECT 
  "customer_id",
  ROUND(MAX("payment_difference"), 4) AS "highest_payment_difference"
FROM (
  SELECT
    "customer_id",
    EXTRACT(YEAR FROM TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "year",
    EXTRACT(MONTH FROM TO_TIMESTAMP("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "month",
    MAX("amount") - MIN("amount") AS "payment_difference"
  FROM 
    "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  WHERE "customer_id" IN (
    SELECT "customer_id"
    FROM (
      SELECT "customer_id", SUM("amount") AS "total_amount"
      FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
      GROUP BY "customer_id"
      ORDER BY "total_amount" DESC
      LIMIT 10
    ) AS "top_customers"
  )
  GROUP BY "customer_id", "year", "month"
) AS "monthly_differences"
GROUP BY "customer_id"
ORDER BY "highest_payment_difference" DESC NULLS LAST
LIMIT 1;