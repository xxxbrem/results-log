WITH state_daily_cases AS (
  SELECT
    "date",
    "state_name",
    "confirmed_cases",
    "confirmed_cases" - COALESCE(LAG("confirmed_cases") OVER (
      PARTITION BY "state_name" ORDER BY "date"
    ), 0) AS daily_new_cases
  FROM
    COVID19_NYT.COVID19_NYT.US_STATES
  WHERE
    "date" BETWEEN '2020-03-01' AND '2020-05-31'
),
state_daily_top5 AS (
  SELECT
    "date",
    "state_name",
    daily_new_cases,
    RANK() OVER (
      PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST
    ) AS state_rank
  FROM
    state_daily_cases
  WHERE
    daily_new_cases IS NOT NULL
),
state_daily_top5_filtered AS (
  SELECT
    *
  FROM
    state_daily_top5
  WHERE
    state_rank <= 5
),
state_top5_appearances AS (
  SELECT
    "state_name",
    COUNT(*) AS appearance_count
  FROM
    state_daily_top5_filtered
  GROUP BY
    "state_name"
),
state_rankings AS (
  SELECT
    "state_name",
    appearance_count,
    RANK() OVER (
      ORDER BY appearance_count DESC NULLS LAST
    ) AS overall_rank
  FROM
    state_top5_appearances
),
fourth_rank_state AS (
  SELECT
    "state_name"
  FROM
    state_rankings
  WHERE
    overall_rank = 4
),
county_daily_cases AS (
  SELECT
    c."date",
    c."state_name",
    c."county",
    c."confirmed_cases",
    c."confirmed_cases" - COALESCE(LAG(c."confirmed_cases") OVER (
      PARTITION BY c."state_name", c."county" ORDER BY c."date"
    ), 0) AS daily_new_cases
  FROM
    COVID19_NYT.COVID19_NYT.US_COUNTIES c
    JOIN fourth_rank_state s ON c."state_name" = s."state_name"
  WHERE
    c."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
county_daily_top5 AS (
  SELECT
    "date",
    "county",
    daily_new_cases,
    RANK() OVER (
      PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST
    ) AS county_rank
  FROM
    county_daily_cases
  WHERE
    daily_new_cases IS NOT NULL
),
county_daily_top5_filtered AS (
  SELECT
    *
  FROM
    county_daily_top5
  WHERE
    county_rank <= 5
),
county_top5_appearances AS (
  SELECT
    "county" AS county_name,
    COUNT(*) AS appearance_count
  FROM
    county_daily_top5_filtered
  GROUP BY
    "county"
)
SELECT
  county_name,
  appearance_count
FROM
  county_top5_appearances
ORDER BY
  appearance_count DESC NULLS LAST
LIMIT
  5;