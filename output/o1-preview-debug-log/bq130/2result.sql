WITH daily_state_new_cases AS (
  SELECT
    date,
    state_name,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name ORDER BY date
    ) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_states`
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
),
state_top5_daily AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    RANK() OVER (
      PARTITION BY date ORDER BY daily_new_cases DESC
    ) AS state_rank
  FROM
    daily_state_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
state_top5_counts AS (
  SELECT
    state_name,
    COUNT(*) AS appearances_in_top_five
  FROM
    state_top5_daily
  WHERE
    state_rank <= 5
  GROUP BY
    state_name
),
state_overall_ranking AS (
  SELECT
    state_name,
    appearances_in_top_five,
    RANK() OVER (ORDER BY appearances_in_top_five DESC) AS overall_rank
  FROM
    state_top5_counts
),
selected_state AS (
  SELECT
    state_name
  FROM
    state_overall_ranking
  WHERE
    overall_rank = 4
),
county_daily_new_cases AS (
  SELECT
    date,
    county,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name, county ORDER BY date
    ) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_counties`
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
    AND state_name = (SELECT state_name FROM selected_state)
),
county_top5_daily AS (
  SELECT
    date,
    county,
    daily_new_cases,
    RANK() OVER (
      PARTITION BY date ORDER BY daily_new_cases DESC
    ) AS county_rank
  FROM
    county_daily_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
county_top5_counts AS (
  SELECT
    county,
    COUNT(*) AS appearances_in_top_five
  FROM
    county_top5_daily
  WHERE
    county_rank <= 5
  GROUP BY
    county
)
SELECT
  CONCAT(county, ' County') AS Top_five_counties,
  appearances_in_top_five AS count
FROM
  county_top5_counts
ORDER BY
  count DESC
LIMIT
  5;