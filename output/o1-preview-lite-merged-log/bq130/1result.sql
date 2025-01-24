WITH state_daily_increases AS (
  SELECT
    date,
    state_name,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY state_name ORDER BY date
    ) AS daily_increase
  FROM `bigquery-public-data.covid19_nyt.us_states`
  WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
),
state_top5 AS (
  SELECT
    date,
    state_name,
    daily_increase,
    ROW_NUMBER() OVER (
      PARTITION BY date ORDER BY daily_increase DESC
    ) AS rank
  FROM state_daily_increases
  WHERE daily_increase IS NOT NULL
),
state_top5_counts AS (
  SELECT
    state_name,
    COUNT(*) AS top5_count
  FROM state_top5
  WHERE rank <= 5
  GROUP BY state_name
),
state_rankings AS (
  SELECT
    state_name,
    top5_count,
    DENSE_RANK() OVER (
      ORDER BY top5_count DESC
    ) AS state_rank
  FROM state_top5_counts
),
state_fourth AS (
  SELECT state_name
  FROM state_rankings
  WHERE state_rank = 4
),
county_daily_increases AS (
  SELECT
    date,
    county,
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY county ORDER BY date
    ) AS daily_increase
  FROM `bigquery-public-data.covid19_nyt.us_counties`
  WHERE state_name = (SELECT state_name FROM state_fourth)
    AND date BETWEEN '2020-03-01' AND '2020-05-31'
),
county_top5 AS (
  SELECT
    date,
    county,
    daily_increase,
    ROW_NUMBER() OVER (
      PARTITION BY date ORDER BY daily_increase DESC
    ) AS rank
  FROM county_daily_increases
  WHERE daily_increase IS NOT NULL
),
county_top5_counts AS (
  SELECT
    county,
    COUNT(*) AS top5_count
  FROM county_top5
  WHERE rank <= 5
  GROUP BY county
)
SELECT CONCAT(county, ' County') AS top_five_counties, top5_count AS count
FROM county_top5_counts
ORDER BY top5_count DESC
LIMIT 5;