WITH cte AS (
    SELECT
        "country_code_2",
        TO_DATE("insert_date") AS insert_date
    FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE "insert_date" LIKE '2022-06%'
    GROUP BY "country_code_2", TO_DATE("insert_date")
),
cte2 AS (
    SELECT
        "country_code_2",
        insert_date,
        ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY insert_date) AS rn,
        DATEDIFF('day', TO_DATE('2022-06-01'), insert_date) AS date_int
    FROM cte
),
cte3 AS (
    SELECT
        "country_code_2",
        (date_int - rn) AS grp
    FROM cte2
),
cte4 AS (
    SELECT
        "country_code_2",
        grp,
        COUNT(*) AS streak_length
    FROM cte3
    GROUP BY "country_code_2", grp
),
cte5 AS (
    SELECT
        "country_code_2",
        MAX(streak_length) AS max_streak
    FROM cte4
    GROUP BY "country_code_2"
),
cte_longest AS (
    SELECT MAX(max_streak) AS longest_streak FROM cte5
)
SELECT
    cte5."country_code_2" AS country_code
FROM cte5
CROSS JOIN cte_longest
WHERE cte5.max_streak = cte_longest.longest_streak;