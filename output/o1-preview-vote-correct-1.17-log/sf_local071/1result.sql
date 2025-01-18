WITH dates AS (
    SELECT DISTINCT "country_code_2", TO_DATE("insert_date") AS "date"
    FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE "insert_date" LIKE '2022-06-%'
),
numbered AS (
    SELECT 
        "country_code_2",
        "date",
        ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY "date") AS rn
    FROM dates
),
groups AS (
    SELECT
        "country_code_2",
        "date",
        rn,
        DATEADD('day', -rn, "date") AS grp
    FROM numbered
),
grouped AS (
    SELECT
        "country_code_2",
        grp,
        COUNT(*) AS streak_length
    FROM groups
    GROUP BY "country_code_2", grp
),
max_streaks AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS "longest_streak_days"
    FROM grouped
    GROUP BY "country_code_2"
),
max_overall AS (
    SELECT MAX("longest_streak_days") AS max_streak
    FROM max_streaks
),
final AS (
    SELECT m."country_code_2", m."longest_streak_days"
    FROM max_streaks m
    JOIN max_overall o
    ON m."longest_streak_days" = o.max_streak
)
SELECT "country_code_2", "longest_streak_days"
FROM final;