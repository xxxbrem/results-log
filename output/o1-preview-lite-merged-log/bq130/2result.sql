WITH state_daily_new_cases AS (
  SELECT
    date,
    state_name,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name
      ORDER BY date
    ) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_states`
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
),
top5_states_daily AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY daily_new_cases DESC
    ) AS rank
  FROM
    state_daily_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
state_top5_counts AS (
  SELECT
    state_name,
    COUNT(*) AS top5_appearances
  FROM
    top5_states_daily
  WHERE
    rank <= 5
  GROUP BY
    state_name
),
state_top5_ranked AS (
  SELECT
    state_name,
    top5_appearances,
    ROW_NUMBER() OVER (
      ORDER BY top5_appearances DESC
    ) AS state_rank
  FROM
    state_top5_counts
),
fourth_ranked_state AS (
  SELECT
    state_name
  FROM
    state_top5_ranked
  WHERE
    state_rank = 4
),
county_daily_new_cases AS (
  SELECT
    date,
    CONCAT(county, ' County') AS county_name,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY county
      ORDER BY date
    ) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_counties` AS uc
  JOIN
    fourth_ranked_state AS frs
  ON
    uc.state_name = frs.state_name
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
),
top5_counties_daily AS (
  SELECT
    date,
    county_name,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY daily_new_cases DESC
    ) AS rank
  FROM
    county_daily_new_cases
  WHERE
    daily_new_cases IS NOT NULL
),
county_top5_counts AS (
  SELECT
    county_name,
    COUNT(*) AS top5_appearances
  FROM
    top5_counties_daily
  WHERE
    rank <= 5
  GROUP BY
    county_name
)
SELECT
  county_name AS top_five_counties,
  top5_appearances AS count
FROM
  county_top5_counts
ORDER BY
  count DESC
LIMIT
  5;