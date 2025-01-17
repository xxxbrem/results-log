WITH customer_monthly_totals AS (
  SELECT
    P."customer_id",
    SUBSTRING(P."payment_date", 1, 7) AS "year_month",
    SUM(P."amount") AS "total_amount"
  FROM
    SQLITE_SAKILA.SQLITE_SAKILA.PAYMENT P
  GROUP BY
    P."customer_id", SUBSTRING(P."payment_date", 1, 7)
),
customer_monthly_changes AS (
  SELECT
    CMT."customer_id",
    CMT."year_month",
    CMT."total_amount",
    LAG(CMT."total_amount") OVER (
      PARTITION BY CMT."customer_id"
      ORDER BY CMT."year_month"
    ) AS "previous_total_amount",
    (CMT."total_amount" - LAG(CMT."total_amount") OVER (
      PARTITION BY CMT."customer_id"
      ORDER BY CMT."year_month"
    )) AS "amount_change"
  FROM
    customer_monthly_totals CMT
),
customer_avg_changes AS (
  SELECT
    CMC."customer_id",
    ROUND(AVG(CMC."amount_change"), 4) AS "avg_monthly_change"
  FROM
    customer_monthly_changes CMC
  WHERE
    CMC."amount_change" IS NOT NULL
  GROUP BY
    CMC."customer_id"
)
SELECT
  C."customer_id",
  C."first_name" || ' ' || C."last_name" AS "full_name"
FROM
  customer_avg_changes AC
  JOIN SQLITE_SAKILA.SQLITE_SAKILA.CUSTOMER C ON AC."customer_id" = C."customer_id"
ORDER BY
  AC."avg_monthly_change" DESC NULLS LAST
LIMIT 1;