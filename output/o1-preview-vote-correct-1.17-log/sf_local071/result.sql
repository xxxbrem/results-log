WITH country_dates AS (
    SELECT
        "country_code_2",
        TO_DATE("insert_date",'YYYY-MM-DD') AS insert_date
    FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE "insert_date" >= '2022-06-01' AND "insert_date" <= '2022-06-30'
    GROUP BY "country_code_2", insert_date
),
numbered_dates AS (
    SELECT
        "country_code_2",
        insert_date,
        ROW_NUMBER() OVER (
            PARTITION BY "country_code_2" 
            ORDER BY insert_date
        ) AS rn
    FROM country_dates
),
datediff_dates AS (
    SELECT
        "country_code_2",
        insert_date,
        rn,
        DATEADD('day', -rn, insert_date) AS grp_date
    FROM numbered_dates
),
streaks AS (
    SELECT
        "country_code_2",
        grp_date,
        COUNT(*) AS streak_length
    FROM datediff_dates
    GROUP BY "country_code_2", grp_date
),
max_streaks AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS max_streak_length
    FROM streaks
    GROUP BY "country_code_2"
)
SELECT "country_code_2"
FROM max_streaks
WHERE max_streak_length = (
    SELECT MAX(max_streak_length)
    FROM max_streaks
);