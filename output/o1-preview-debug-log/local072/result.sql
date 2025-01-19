WITH
country_dates AS (
    SELECT "country_code_2", COUNT(DISTINCT "insert_date") AS num_dates
    FROM "cities"
    WHERE "insert_date" BETWEEN '2022-01-01' AND '2022-01-31'
    GROUP BY "country_code_2"
    HAVING num_dates = 9
),
selected_country AS (
    SELECT "country_code_2"
    FROM country_dates
    LIMIT 1
),
insert_dates AS (
    SELECT DISTINCT "insert_date"
    FROM "cities"
    WHERE "country_code_2" = (SELECT "country_code_2" FROM selected_country)
      AND "insert_date" BETWEEN '2022-01-01' AND '2022-01-31'
),
numbered_dates AS (
    SELECT
        "insert_date",
        julianday("insert_date") AS date_num,
        ROW_NUMBER() OVER (ORDER BY julianday("insert_date")) AS rn
    FROM insert_dates
),
groups AS (
    SELECT
        "insert_date",
        date_num,
        rn,
        date_num - rn AS grp
    FROM numbered_dates
),
longest_sequence AS (
    SELECT
        MIN("insert_date") AS start_date,
        MAX("insert_date") AS end_date,
        COUNT(*) AS days_in_sequence
    FROM groups
    GROUP BY grp
    ORDER BY days_in_sequence DESC
    LIMIT 1
),
country_info AS (
    SELECT "country_code_2", "country_name"
    FROM "cities_countries"
    WHERE "country_code_2" = (SELECT "country_code_2" FROM selected_country)
),
entries_in_period AS (
    SELECT *
    FROM "cities"
    WHERE "country_code_2" = (SELECT "country_code_2" FROM selected_country)
      AND "insert_date" BETWEEN (SELECT start_date FROM longest_sequence) AND (SELECT end_date FROM longest_sequence)
)
SELECT
    country_info."country_name" AS Country,
    (SELECT start_date FROM longest_sequence) AS Start_Date,
    (SELECT end_date FROM longest_sequence) AS End_Date,
    ROUND(SUM(CASE WHEN entries_in_period."capital" = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 4) AS Proportion
FROM entries_in_period
CROSS JOIN country_info;