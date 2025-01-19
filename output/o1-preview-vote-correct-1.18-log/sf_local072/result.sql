WITH country_dates AS (
    SELECT DISTINCT TO_DATE("insert_date") AS "insert_date"
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES"
    WHERE LOWER(TRIM(COALESCE("country_code_2", ''))) = 'ir'
      AND "insert_date" LIKE '2022-01%'
), numbered_dates AS (
    SELECT 
        "insert_date",
        ROW_NUMBER() OVER (ORDER BY "insert_date") AS seqnum
    FROM country_dates
), date_groups AS (
    SELECT 
        "insert_date",
        DATEADD('day', -seqnum, "insert_date") AS grp
    FROM numbered_dates
), periods AS (
    SELECT 
        grp,
        MIN("insert_date") AS "start_date",
        MAX("insert_date") AS "end_date",
        COUNT(*) AS "days_in_sequence"
    FROM date_groups
    GROUP BY grp
), longest_period AS (
    SELECT "start_date", "end_date", "days_in_sequence"
    FROM periods
    ORDER BY "days_in_sequence" DESC NULLS LAST
    LIMIT 1
), entries_in_period AS (
    SELECT *
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES"
    WHERE LOWER(TRIM(COALESCE("country_code_2", ''))) = 'ir'
      AND TO_DATE("insert_date") BETWEEN (SELECT "start_date" FROM longest_period) AND (SELECT "end_date" FROM longest_period)
)
SELECT
    ROUND(
        (SUM(CASE WHEN LOWER(TRIM(COALESCE("city_name", ''))) = 'tehran' THEN 1 ELSE 0 END)::FLOAT)
        / NULLIF(COUNT(*), 0), 4
    ) AS "proportion"
FROM entries_in_period;