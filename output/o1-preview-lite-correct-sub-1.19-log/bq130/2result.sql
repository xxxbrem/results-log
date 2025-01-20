WITH daily_state_cases AS (
  SELECT
    date,
    state_name,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY state_name ORDER BY date) AS daily_new_cases
  FROM `bigquery-public-data.covid19_nyt.us_states`
  WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
),
top_states_per_day AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    ROW_NUMBER() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS daily_rank
  FROM daily_state_cases
  WHERE daily_new_cases IS NOT NULL
),
state_top_counts AS (
  SELECT
    state_name,
    COUNT(*) AS frequency
  FROM top_states_per_day
  WHERE daily_rank <= 5
  GROUP BY state_name
),
state_rankings AS (
  SELECT
    state_name,
    frequency,
    ROW_NUMBER() OVER (ORDER BY frequency DESC) AS state_rank
  FROM state_top_counts
),
selected_state AS (
  SELECT
    state_name
  FROM state_rankings
  WHERE state_rank = 4
),
daily_county_cases AS (
  SELECT
    date,
    county,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY county ORDER BY date) AS daily_new_cases
  FROM `bigquery-public-data.covid19_nyt.us_counties`
  WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
    AND state_name = (SELECT state_name FROM selected_state)
),
top_counties_per_day AS (
  SELECT
    date,
    county,
    daily_new_cases,
    ROW_NUMBER() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS daily_rank
  FROM daily_county_cases
  WHERE daily_new_cases IS NOT NULL
),
county_top_counts AS (
  SELECT
    county AS County,
    COUNT(*) AS Frequency
  FROM top_counties_per_day
  WHERE daily_rank <= 5
  GROUP BY county
),
final_result AS (
  SELECT
    County,
    Frequency
  FROM county_top_counts
  ORDER BY Frequency DESC
  LIMIT 5
)
SELECT * FROM final_result;