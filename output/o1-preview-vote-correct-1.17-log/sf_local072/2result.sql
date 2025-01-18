WITH dates AS (
    SELECT 
        TO_DATE("insert_date", 'YYYY-MM-DD') AS insert_date,
        ROW_NUMBER() OVER (ORDER BY TO_DATE("insert_date", 'YYYY-MM-DD')) AS rn
    FROM (
        SELECT DISTINCT "insert_date"
        FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
        WHERE "country_code_2" = 'ir' AND "insert_date" LIKE '2022-01-%'
    )
),
date_groups AS (
    SELECT
        insert_date,
        rn,
        DATEADD('day', -rn, insert_date) AS grp
    FROM dates
),
grouped_dates AS (
    SELECT
        grp,
        MIN(insert_date) AS start_date,
        MAX(insert_date) AS end_date,
        COUNT(*) AS num_days
    FROM date_groups
    GROUP BY grp
),
longest_period AS (
    SELECT start_date, end_date, num_days
    FROM grouped_dates
    ORDER BY num_days DESC NULLS LAST
    LIMIT 1
),
total_entries AS (
    SELECT COUNT(*) AS total_count
    FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES c, longest_period
    WHERE c."country_code_2" = 'ir'
      AND TO_DATE(c."insert_date", 'YYYY-MM-DD') BETWEEN longest_period.start_date AND longest_period.end_date
),
capital_entries AS (
    SELECT COUNT(*) AS capital_count
    FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES c, longest_period
    WHERE c."country_code_2" = 'ir'
      AND TO_DATE(c."insert_date", 'YYYY-MM-DD') BETWEEN longest_period.start_date AND longest_period.end_date
      AND c."capital" = 1
)
SELECT
    cc."country_name",
    longest_period.num_days AS longest_consecutive_days,
    ROUND(capital_entries.capital_count / total_entries.total_count::FLOAT, 4) AS proportion_from_capital
FROM longest_period
CROSS JOIN total_entries
CROSS JOIN capital_entries
JOIN CITY_LEGISLATION.CITY_LEGISLATION.CITIES_COUNTRIES cc ON cc."country_code_2" = 'ir';