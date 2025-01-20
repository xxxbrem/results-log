WITH daily_state_cases AS (
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
daily_top_states AS (
  SELECT
    date,
    state_name,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY daily_new_cases DESC, state_name
    ) AS state_rank
  FROM
    daily_state_cases
  WHERE
    daily_new_cases > 0
),
state_frequency AS (
  SELECT
    state_name,
    COUNTIF(state_rank <= 5) AS top5_frequency
  FROM
    daily_top_states
  GROUP BY
    state_name
),
fourth_ranked_state AS (
  SELECT
    state_name
  FROM (
    SELECT
      state_name,
      top5_frequency,
      ROW_NUMBER() OVER (
        ORDER BY top5_frequency DESC, state_name
      ) AS overall_rank
    FROM
      state_frequency
  )
  WHERE
    overall_rank = 4
),
daily_county_cases AS (
  SELECT
    date,
    county,
    confirmed_cases - LAG(confirmed_cases) OVER (
      PARTITION BY county
      ORDER BY date
    ) AS daily_new_cases
  FROM
    `bigquery-public-data.covid19_nyt.us_counties`
  WHERE
    date BETWEEN '2020-03-01' AND '2020-05-31'
    AND state_name = (SELECT state_name FROM fourth_ranked_state)
),
daily_top_counties AS (
  SELECT
    date,
    county,
    daily_new_cases,
    ROW_NUMBER() OVER (
      PARTITION BY date
      ORDER BY daily_new_cases DESC, county
    ) AS county_rank
  FROM
    daily_county_cases
  WHERE
    daily_new_cases > 0
),
county_frequency AS (
  SELECT
    county,
    COUNTIF(county_rank <= 5) AS top5_frequency
  FROM
    daily_top_counties
  GROUP BY
    county
)
SELECT
  CONCAT(county, ' County') AS County,
  top5_frequency AS Frequency
FROM
  county_frequency
ORDER BY
  Frequency DESC,
  County
LIMIT
  5;