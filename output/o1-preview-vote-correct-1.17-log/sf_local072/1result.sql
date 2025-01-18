WITH country AS (
  SELECT 'ir' AS "country_code_2"
),
country_dates AS (
  SELECT DISTINCT CAST("insert_date" AS DATE) AS "date"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
  WHERE "insert_date" LIKE '2022-01%' AND "country_code_2" = 'ir'
),
ordered_dates AS (
  SELECT "date",
    ROW_NUMBER() OVER (ORDER BY "date") AS "rn"
  FROM country_dates
),
grouped_dates AS (
  SELECT "date",
    "rn",
    DATEADD('day', - "rn", "date") AS grp
  FROM ordered_dates
),
periods AS (
  SELECT
    grp,
    MIN("date") AS start_date,
    MAX("date") AS end_date,
    COUNT(*) AS day_count
  FROM grouped_dates
  GROUP BY grp
),
longest_period AS (
  SELECT start_date, end_date
  FROM periods
  ORDER BY day_count DESC NULLS LAST, start_date
  LIMIT 1
),
entries AS (
  SELECT
    COUNT(*) AS total_entries,
    SUM(CASE WHEN "capital" = 1 THEN 1 ELSE 0 END) AS capital_entries
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES, longest_period
  WHERE "country_code_2" = 'ir'
    AND CAST("insert_date" AS DATE) BETWEEN longest_period.start_date AND longest_period.end_date
)
SELECT ROUND(capital_entries / total_entries::FLOAT, 4) AS proportion
FROM entries;