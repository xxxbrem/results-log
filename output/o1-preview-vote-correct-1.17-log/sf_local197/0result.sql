WITH customer_totals AS (
    SELECT "customer_id", SUM("amount") AS total_payment
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT
    GROUP BY "customer_id"
),
top_customers AS (
    SELECT "customer_id", total_payment,
           RANK() OVER (ORDER BY total_payment DESC NULLS LAST) AS rank
    FROM customer_totals
    QUALIFY rank <= 10
),
monthly_totals AS (
    SELECT p."customer_id",
           SUBSTRING(p."payment_date", 1, 7) AS "year_month",
           SUM(p."amount") AS monthly_total
    FROM SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT p
    WHERE p."customer_id" IN (SELECT "customer_id" FROM top_customers)
    GROUP BY p."customer_id", "year_month"
),
monthly_differences AS (
    SELECT t1."customer_id",
           ABS(t1.monthly_total - t2.monthly_total) AS diff
    FROM monthly_totals t1
    JOIN monthly_totals t2 
        ON t1."customer_id" = t2."customer_id"
        AND t1."year_month" < t2."year_month"
),
customer_max_diff AS (
    SELECT "customer_id", MAX(ROUND(diff, 4)) AS max_diff
    FROM monthly_differences
    GROUP BY "customer_id"
),
max_diff_overall AS (
    SELECT MAX(max_diff) AS highest_max_diff
    FROM customer_max_diff
),
customer_with_max_diff AS (
    SELECT c."customer_id", c.max_diff
    FROM customer_max_diff c
    JOIN max_diff_overall m ON c.max_diff = m.highest_max_diff
    LIMIT 1
)
SELECT c."customer_id",
       c."first_name" || ' ' || c."last_name" AS customer_name,
       ROUND(m.max_diff, 2) AS highest_payment_difference
FROM customer_with_max_diff m
JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER c ON c."customer_id" = m."customer_id";