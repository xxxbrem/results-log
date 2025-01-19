WITH january_data AS (
  SELECT
    "country_code_2",
    "city_name",
    "capital",
    TRY_TO_DATE("insert_date", 'YYYY-MM-DD') AS "parsed_date"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
  WHERE
    TRY_TO_DATE("insert_date", 'YYYY-MM-DD') BETWEEN '2022-01-01' AND '2022-01-31'
    AND "insert_date" IS NOT NULL
),
countries_with_9_days AS (
  SELECT "country_code_2"
  FROM january_data
  GROUP BY "country_code_2"
  HAVING COUNT(DISTINCT "parsed_date") = 9
),
country_dates AS (
  SELECT DISTINCT "country_code_2", "parsed_date"
  FROM january_data
  WHERE "country_code_2" IN (SELECT "country_code_2" FROM countries_with_9_days)
),
numbered_dates AS (
  SELECT
    "country_code_2",
    "parsed_date",
    ROW_NUMBER() OVER (PARTITION BY "country_code_2" ORDER BY "parsed_date") AS rn
  FROM country_dates
),
grouped_dates AS (
  SELECT
    "country_code_2",
    "parsed_date",
    rn,
    DATEADD('day', -rn, "parsed_date") AS grp
  FROM numbered_dates
),
longest_sequence AS (
  SELECT
    "country_code_2",
    grp,
    MIN("parsed_date") AS start_date,
    MAX("parsed_date") AS end_date,
    COUNT(*) AS num_days
  FROM grouped_dates
  GROUP BY "country_code_2", grp
  ORDER BY num_days DESC NULLS LAST, "country_code_2"
  LIMIT 1
),
entries_in_period AS (
  SELECT c.*
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES c
  JOIN longest_sequence ls ON c."country_code_2" = ls."country_code_2"
  WHERE
    TRY_TO_DATE(c."insert_date", 'YYYY-MM-DD') BETWEEN ls.start_date AND ls.end_date
    AND c."insert_date" IS NOT NULL
),
capital_city AS (
  SELECT DISTINCT "city_name"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES
  WHERE
    "country_code_2" = (SELECT "country_code_2" FROM longest_sequence)
    AND "capital" = 1
),
country_name AS (
  SELECT "country_code_2", "country_name"
  FROM CITY_LEGISLATION.CITY_LEGISLATION.CITIES_COUNTRIES
)
SELECT
  cn."country_name" AS "Country_name",
  ROUND(
    SUM(CASE WHEN LOWER(e."city_name") = LOWER(cc."city_name") THEN 1 ELSE 0 END)::FLOAT
    / NULLIF(COUNT(*), 0),
    4
  ) AS "Proportion_from_capital_city"
FROM entries_in_period e
CROSS JOIN capital_city cc
JOIN country_name cn ON e."country_code_2" = cn."country_code_2"
GROUP BY cn."country_name";