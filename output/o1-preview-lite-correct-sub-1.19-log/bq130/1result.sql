WITH state_daily_new_cases AS (
    SELECT
        date,
        state_name,
        confirmed_cases,
        confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY state_name ORDER BY date) AS daily_new_cases
    FROM `bigquery-public-data.covid19_nyt.us_states`
    WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
)
, top_states_per_date AS (
    SELECT
        date,
        state_name,
        daily_new_cases,
        ROW_NUMBER() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS state_rank
    FROM state_daily_new_cases
    WHERE daily_new_cases IS NOT NULL AND daily_new_cases >= 0
)
, top_five_states_per_date AS (
    SELECT *
    FROM top_states_per_date
    WHERE state_rank <=5
)
, state_top_five_frequency AS (
    SELECT
        state_name,
        COUNT(*) AS frequency
    FROM top_five_states_per_date
    GROUP BY state_name
)
, ranked_states AS (
    SELECT
        state_name,
        frequency,
        DENSE_RANK() OVER (ORDER BY frequency DESC) AS state_overall_rank
    FROM state_top_five_frequency
)
, fourth_ranked_states AS (
    SELECT state_name
    FROM ranked_states
    WHERE state_overall_rank = 4
)
, county_daily_new_cases AS (
    SELECT
        date,
        county,
        state_name,
        confirmed_cases,
        confirmed_cases - LAG(confirmed_cases) OVER (PARTITION BY state_name, county ORDER BY date) AS daily_new_cases
    FROM `bigquery-public-data.covid19_nyt.us_counties`
    WHERE date BETWEEN '2020-03-01' AND '2020-05-31'
        AND state_name IN (SELECT state_name FROM fourth_ranked_states)
)
, top_counties_per_date AS (
    SELECT
        date,
        county,
        daily_new_cases,
        ROW_NUMBER() OVER (PARTITION BY date, state_name ORDER BY daily_new_cases DESC) AS county_rank_within_state
    FROM county_daily_new_cases
    WHERE daily_new_cases IS NOT NULL AND daily_new_cases >= 0
)
, top_five_counties_per_date AS (
    SELECT *
    FROM top_counties_per_date
    WHERE county_rank_within_state <=5
)
, county_top_five_frequency AS (
    SELECT
        county,
        COUNT(*) AS frequency
    FROM top_five_counties_per_date
    GROUP BY county
)
SELECT
    county AS County,
    frequency AS Frequency
FROM county_top_five_frequency
ORDER BY frequency DESC, county ASC
LIMIT 5