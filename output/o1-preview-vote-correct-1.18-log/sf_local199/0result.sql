SELECT
  S."store_id",
  EXTRACT(YEAR FROM TO_TIMESTAMP(R."rental_date")) AS "year",
  EXTRACT(MONTH FROM TO_TIMESTAMP(R."rental_date")) AS "month",
  COUNT(*) AS "total_rentals"
FROM
  "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" R
JOIN
  "SQLITE_SAKILA"."SQLITE_SAKILA"."STAFF" S
  ON R."staff_id" = S."staff_id"
GROUP BY
  S."store_id",
  "year",
  "month"
QUALIFY
  ROW_NUMBER() OVER (
    PARTITION BY S."store_id"
    ORDER BY COUNT(*) DESC NULLS LAST
  ) = 1