WITH country_with_nine_days AS (
    SELECT "country_code_2"
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES"
    WHERE "insert_date" LIKE '2022-01-%'
    GROUP BY "country_code_2"
    HAVING COUNT(DISTINCT "insert_date") = 9
),
insert_dates AS (
    SELECT DISTINCT TO_DATE("insert_date") AS "insert_date"
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES" c
    JOIN country_with_nine_days c9 ON c."country_code_2" = c9."country_code_2"
    WHERE c."insert_date" LIKE '2022-01-%'
),
date_sequences AS (
    SELECT
        "insert_date",
        ROW_NUMBER() OVER (ORDER BY "insert_date") AS rn,
        DATEDIFF('day', DATE '2022-01-01', "insert_date") - ROW_NUMBER() OVER (ORDER BY "insert_date") AS grp
    FROM insert_dates
),
sequences AS (
    SELECT
        grp,
        MIN("insert_date") AS "start_date",
        MAX("insert_date") AS "end_date",
        COUNT(*) AS day_count
    FROM date_sequences
    GROUP BY grp
),
longest_sequence AS (
    SELECT
        "start_date",
        "end_date",
        day_count
    FROM sequences
    ORDER BY day_count DESC NULLS LAST, "start_date"
    LIMIT 1
)
SELECT
    ROUND(SUM(CASE WHEN c."capital" = 1 THEN 1 ELSE 0 END)::FLOAT / COUNT(*), 4) AS "proportion"
FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES" c
JOIN country_with_nine_days c9 ON c."country_code_2" = c9."country_code_2"
CROSS JOIN longest_sequence ls
WHERE TO_DATE(c."insert_date") BETWEEN ls."start_date" AND ls."end_date";