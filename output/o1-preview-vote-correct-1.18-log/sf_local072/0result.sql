WITH dates AS (
    SELECT DISTINCT TRY_TO_DATE("insert_date", 'YYYY-MM-DD') AS date
    FROM CITY_LEGISLATION.CITY_LEGISLATION."CITIES"
    WHERE "country_code_2" = 'ir' AND "insert_date" LIKE '2022-01-%'
),
ordered_dates AS (
    SELECT date, ROW_NUMBER() OVER (ORDER BY date) AS rn
    FROM dates
),
grouped_dates AS (
    SELECT date, rn, DATEADD('day', -rn, date) AS grp
    FROM ordered_dates
),
groups AS (
    SELECT grp, MIN(date) AS start_date, MAX(date) AS end_date, COUNT(*) AS period_length
    FROM grouped_dates
    GROUP BY grp
    ORDER BY period_length DESC NULLS LAST
    LIMIT 1
),
capital_city AS (
    SELECT "city_name" AS capital_city_name
    FROM CITY_LEGISLATION.CITY_LEGISLATION."CITIES"
    WHERE "country_code_2" = 'ir' AND "capital" = 1
    LIMIT 1
),
period_data AS (
    SELECT
        "city_name",
        TRY_TO_DATE("insert_date", 'YYYY-MM-DD') AS date
    FROM CITY_LEGISLATION.CITY_LEGISLATION."CITIES"
    WHERE "country_code_2" = 'ir'
      AND TRY_TO_DATE("insert_date", 'YYYY-MM-DD') BETWEEN (SELECT start_date FROM groups) AND (SELECT end_date FROM groups)
)
SELECT
    'Iran' AS Country,
    (SELECT period_length FROM groups) AS Longest_Consecutive_Period_Length,
    ROUND(SUM(CASE WHEN LOWER("city_name") = LOWER((SELECT capital_city_name FROM capital_city)) THEN 1 ELSE 0 END)::FLOAT / COUNT(*), 4) AS Proportion_of_Capital_City_Entries
FROM period_data;