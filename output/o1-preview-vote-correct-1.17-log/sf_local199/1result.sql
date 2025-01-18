WITH rentals_per_month AS (
  SELECT
    S."store_id",
    EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(R."rental_date")) AS "year",
    EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ(R."rental_date")) AS "month",
    COUNT(*) AS total_rentals
  FROM
    "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" R
  JOIN
    "SQLITE_SAKILA"."SQLITE_SAKILA"."STAFF" S ON R."staff_id" = S."staff_id"
  GROUP BY
    S."store_id",
    EXTRACT(YEAR FROM TO_TIMESTAMP_NTZ(R."rental_date")),
    EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ(R."rental_date"))
),
ranked_rentals AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY "store_id" ORDER BY total_rentals DESC NULLS LAST) AS rn
  FROM
    rentals_per_month
)
SELECT
  "store_id",
  "year",
  "month",
  total_rentals
FROM
  ranked_rentals
WHERE
  rn = 1
ORDER BY
  "store_id";