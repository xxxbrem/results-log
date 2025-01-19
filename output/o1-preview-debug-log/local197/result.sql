WITH top_customers AS (
    SELECT "customer_id"
    FROM (
        SELECT "customer_id", SUM("amount") AS "total_payment"
        FROM "payment"
        GROUP BY "customer_id"
        ORDER BY "total_payment" DESC
        LIMIT 10
    )
),
monthly_totals AS (
    SELECT "customer_id", strftime('%Y-%m', "payment_date") AS "month", SUM("amount") AS "monthly_total"
    FROM "payment"
    WHERE "customer_id" IN (SELECT "customer_id" FROM top_customers)
    GROUP BY "customer_id", "month"
),
monthly_diffs AS (
    SELECT mt1."customer_id",
           ABS(mt1."monthly_total" - mt2."monthly_total") AS "diff"
    FROM monthly_totals mt1
    JOIN monthly_totals mt2
      ON mt1."customer_id" = mt2."customer_id"
     AND mt1."month" < mt2."month"
),
max_diffs AS (
    SELECT "customer_id", MAX("diff") AS "max_diff"
    FROM monthly_diffs
    GROUP BY "customer_id"
)
SELECT c."first_name" || ' ' || c."last_name" AS "Customer_Name",
       ROUND(md."max_diff", 4) AS "Highest_Payment_Difference"
FROM max_diffs md
JOIN "customer" c ON c."customer_id" = md."customer_id"
ORDER BY md."max_diff" DESC
LIMIT 1;