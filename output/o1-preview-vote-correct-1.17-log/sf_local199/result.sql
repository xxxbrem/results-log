SELECT
    t."store_id",
    t."year",
    t."month",
    t."total_rentals"
FROM (
    SELECT
        s."store_id",
        EXTRACT(YEAR FROM TO_TIMESTAMP(SUBSTRING(r."rental_date", 1, 19), 'YYYY-MM-DD HH24:MI:SS')) AS "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP(SUBSTRING(r."rental_date", 1, 19), 'YYYY-MM-DD HH24:MI:SS')) AS "month",
        COUNT(*) AS "total_rentals",
        ROW_NUMBER() OVER (
            PARTITION BY s."store_id"
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS rn
    FROM
        "SQLITE_SAKILA"."SQLITE_SAKILA"."RENTAL" AS r
    JOIN
        "SQLITE_SAKILA"."SQLITE_SAKILA"."STAFF" AS s
        ON
            r."staff_id" = s."staff_id"
    WHERE
        TO_TIMESTAMP(SUBSTRING(r."rental_date", 1, 19), 'YYYY-MM-DD HH24:MI:SS') IS NOT NULL
    GROUP BY
        s."store_id",
        "year",
        "month"
) AS t
WHERE
    t.rn = 1;