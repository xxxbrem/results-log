WITH date_list AS (
    SELECT DISTINCT "country_code_2", "insert_date"
    FROM "cities"
    WHERE "insert_date" BETWEEN '2022-06-01' AND '2022-06-30'
),
dated_rows AS (
    SELECT
        "country_code_2",
        "insert_date",
        julianday("insert_date") AS jd,
        ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY "insert_date") AS rn
    FROM date_list
),
groups AS (
    SELECT
        "country_code_2",
        "insert_date",
        jd,
        rn,
        jd - rn AS grp
    FROM dated_rows
),
streaks AS (
    SELECT
        "country_code_2",
        COUNT(*) AS streak_length
        FROM groups
    GROUP BY "country_code_2", grp
),
max_streaks AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS max_streak_length
    FROM streaks
    GROUP BY "country_code_2"
),
overall_max AS (
    SELECT MAX(max_streak_length) AS max_streak_length
    FROM max_streaks
)
SELECT
    "country_code_2"
FROM
    max_streaks
WHERE
    max_streak_length = (SELECT max_streak_length FROM overall_max)
;