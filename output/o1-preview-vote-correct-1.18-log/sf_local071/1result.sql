WITH parsed_cities AS (
    SELECT
        "country_code_2",
        TRY_TO_DATE("insert_date", 'YYYY-MM-DD') AS insert_date
    FROM
        CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE
        TRY_TO_DATE("insert_date", 'YYYY-MM-DD') BETWEEN '2022-06-01' AND '2022-06-30'
),
unique_dates AS (
    SELECT DISTINCT
        "country_code_2",
        insert_date
    FROM parsed_cities
),
numbered_dates AS (
    SELECT
        "country_code_2",
        insert_date,
        DATEDIFF('day', '1970-01-01', insert_date) AS date_serial_number,
        ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY insert_date) AS rn
    FROM unique_dates
),
streaks AS (
    SELECT
        "country_code_2",
        (date_serial_number - rn) AS group_id,
        COUNT(*) AS streak_length
    FROM numbered_dates
    GROUP BY "country_code_2", group_id
),
max_streaks AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS max_streak_length
    FROM streaks
    GROUP BY "country_code_2"
),
longest_streak_length AS (
    SELECT MAX(max_streak_length) AS longest_streak FROM max_streaks
)
SELECT
    "country_code_2" AS country_code
FROM max_streaks, longest_streak_length
WHERE max_streak_length = longest_streak
ORDER BY "country_code_2";