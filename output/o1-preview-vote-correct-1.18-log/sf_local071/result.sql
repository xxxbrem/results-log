WITH date_conversions AS (
    SELECT
        "country_code_2",
        TO_DATE("insert_date", 'YYYY-MM-DD') AS "date"
    FROM
        CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE
        "insert_date" BETWEEN '2022-06-01' AND '2022-06-30'
),
country_dates AS (
    SELECT DISTINCT
        "country_code_2",
        "date"
    FROM
        date_conversions
),
date_sequences AS (
    SELECT
        "country_code_2",
        "date",
        ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY "date") AS rn,
        DATEADD(
            day,
            -ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY "date"),
            "date"
        ) AS grp
    FROM
        country_dates
),
streaks AS (
    SELECT
        "country_code_2",
        COUNT(*) AS streak_length
    FROM
        date_sequences
    GROUP BY
        "country_code_2",
        grp
),
max_streaks AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS max_streak
    FROM
        streaks
    GROUP BY
        "country_code_2"
),
overall_max AS (
    SELECT MAX(max_streak) AS longest_streak FROM max_streaks
)
SELECT
    m."country_code_2"
FROM
    max_streaks m
WHERE
    m.max_streak = (SELECT longest_streak FROM overall_max);