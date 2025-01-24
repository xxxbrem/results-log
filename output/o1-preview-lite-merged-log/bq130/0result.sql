WITH state_daily_new_cases AS (
  SELECT
    date,
    state_name,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY state_name ORDER BY date) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_states`
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
),
state_daily_ranks AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    ROW_NUMBER() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS rank
  FROM
    state_daily_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
state_top5_counts AS (
  SELECT
    state_name,
    COUNT(*) AS appearance_count
  FROM
    state_daily_ranks
  WHERE
    rank <= 5
  GROUP BY
    state_name
),
state_ranking AS (
  SELECT
    state_name,
    appearance_count,
    ROW_NUMBER() OVER (ORDER BY appearance_count DESC) AS state_rank
  FROM
    state_top5_counts
),
fourth_state AS (
  SELECT
    state_name
  FROM
    state_ranking
  WHERE
    state_rank = 4
),
county_daily_new_cases AS (
  SELECT
    date,
    county,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY county ORDER BY date) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_counties` AS uc
  JOIN
    fourth_state AS fs ON uc.state_name = fs.state_name
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
),
county_daily_ranks AS (
  SELECT
    date,
    county,
    daily_new_cases,
    ROW_NUMBER() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS rank
  FROM
    county_daily_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
county_top5_counts AS (
  SELECT
    county,
    COUNT(*) AS appearance_count
  FROM
    county_daily_ranks
  WHERE
    rank <= 5
  GROUP BY
    county
  ORDER BY
    appearance_count DESC
  LIMIT 5
)
SELECT
  county,
  appearance_count
FROM
  county_top5_counts;