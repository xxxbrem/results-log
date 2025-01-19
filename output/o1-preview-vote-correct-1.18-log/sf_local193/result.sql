WITH customer_ltv AS (
  SELECT "customer_id", 
         MIN(TRY_TO_TIMESTAMP_NTZ("payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3')) AS "first_purchase_date", 
         SUM("amount") AS "total_ltv"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT"
  GROUP BY "customer_id"
),
payments_with_ltv AS (
  SELECT p."customer_id", 
         p."amount", 
         TRY_TO_TIMESTAMP_NTZ(p."payment_date", 'YYYY-MM-DD HH24:MI:SS.FF3') AS "payment_date", 
         ltv."first_purchase_date", 
         ltv."total_ltv"
  FROM "SQLITE_SAKILA"."SQLITE_SAKILA"."PAYMENT" p
  JOIN customer_ltv ltv ON p."customer_id" = ltv."customer_id"
),
customers_payments AS (
  SELECT 
    pwl."customer_id",
    pwl."total_ltv",
    SUM(CASE WHEN TIMESTAMPDIFF('second', pwl."first_purchase_date", pwl."payment_date") <= 7 * 24 * 60 * 60 THEN pwl."amount" ELSE 0 END) AS "ltv_7_days",
    SUM(CASE WHEN TIMESTAMPDIFF('second', pwl."first_purchase_date", pwl."payment_date") <= 30 * 24 * 60 * 60 THEN pwl."amount" ELSE 0 END) AS "ltv_30_days"
  FROM payments_with_ltv pwl
  GROUP BY pwl."customer_id", pwl."total_ltv"
)
SELECT 
  ROUND(AVG("total_ltv"), 4) AS "Average_Total_LTV",
  ROUND(AVG(("ltv_7_days" / "total_ltv") * 100), 4) || '%' AS "Average_7_Day_Percentage",
  ROUND(AVG(("ltv_30_days" / "total_ltv") * 100), 4) || '%' AS "Average_30_Day_Percentage"
FROM customers_payments
WHERE "total_ltv" > 0;