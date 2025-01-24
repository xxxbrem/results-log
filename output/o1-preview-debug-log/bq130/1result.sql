WITH state_daily_new_cases AS (
  SELECT
    date,
    state_name,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name ORDER BY date
    ) AS daily_new_cases
  FROM `bigquery-public-data.covid19_nyt.us_states`
  WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
),
state_top_five_daily AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date ORDER BY daily_new_cases DESC, state_name
    ) AS rank
  FROM state_daily_new_cases
  WHERE daily_new_cases IS NOT NULL AND daily_new_cases > 0
),
state_top_five_counts AS (
  SELECT
    state_name,
    COUNT(*) AS top_five_appearances
  FROM state_top_five_daily
  WHERE rank <= 5
  GROUP BY state_name
),
fourth_ranked_state AS (
  SELECT state_name
  FROM state_top_five_counts
  ORDER BY top_five_appearances DESC, state_name
  LIMIT 1 OFFSET 3
),
county_daily_new_cases AS (
  SELECT
    date,
    county,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name, county ORDER BY date
    ) AS daily_new_cases
  FROM `bigquery-public-data.covid19_nyt.us_counties`
  WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
    AND state_name = (SELECT state_name FROM fourth_ranked_state)
),
county_top_five_daily AS (
  SELECT
    date,
    county,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date ORDER BY daily_new_cases DESC, county
    ) AS rank
  FROM county_daily_new_cases
  WHERE daily_new_cases IS NOT NULL AND daily_new_cases > 0
),
county_top_five_counts AS (
  SELECT
    county,
    COUNT(*) AS top_five_appearances
  FROM county_top_five_daily
  WHERE rank <= 5
  GROUP BY county
)
SELECT
  CONCAT(county, ' County') AS `Top_five_counties`,
  top_five_appearances AS `count`
FROM county_top_five_counts
ORDER BY top_five_appearances DESC
LIMIT 5;