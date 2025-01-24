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
state_top5_daily AS (
  SELECT 
    date,
    state_name,
    daily_new_cases,
    RANK() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS state_rank
  FROM 
    state_daily_new_cases
  WHERE 
    daily_new_cases IS NOT NULL AND daily_new_cases >= 0
),
state_top5_only AS (
  SELECT 
    date,
    state_name,
    daily_new_cases
  FROM 
    state_top5_daily
  WHERE 
    state_rank <= 5
),
state_top5_counts AS (
  SELECT
    state_name,
    COUNT(*) AS appearances
  FROM
    state_top5_only
  GROUP BY
    state_name
),
state_overall_ranking AS (
  SELECT
    state_name,
    appearances,
    ROW_NUMBER() OVER (ORDER BY appearances DESC) AS overall_rank
  FROM
    state_top5_counts
),
state_ranked_fourth AS (
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
    confirmed_cases,
    confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY state_name, county ORDER BY date) AS daily_new_cases
  FROM 
    `bigquery-public-data.covid19_nyt.us_counties`
  WHERE 
    date BETWEEN '2020-03-01' AND '2020-05-31'
    AND state_name = (SELECT state_name FROM state_ranked_fourth)
),
county_top5_daily AS (
  SELECT 
    date,
    county,
    daily_new_cases,
    RANK() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS county_rank
  FROM 
    county_daily_new_cases
  WHERE 
    daily_new_cases IS NOT NULL AND daily_new_cases >= 0
),
county_top5_only AS (
  SELECT 
    date,
    county,
    daily_new_cases
  FROM 
    county_top5_daily
  WHERE 
    county_rank <= 5
),
county_top5_counts AS (
  SELECT
    county,
    COUNT(*) AS appearances
  FROM
    county_top5_only
  GROUP BY
    county
),
county_overall_ranking AS (
  SELECT
    county,
    appearances,
    ROW_NUMBER() OVER (ORDER BY appearances DESC) AS overall_rank
  FROM
    county_top5_counts
)
-- Final result: Top 5 counties in the fourth-ranked state by appearances in daily top 5 new case counts
SELECT
  county AS Top_five_counties,
  appearances AS count
FROM
  county_overall_ranking
WHERE
  overall_rank <= 5
ORDER BY
  appearances DESC;