WITH state_daily_new_cases AS (
    SELECT
        date,
        state_name,
        confirmed_cases,
        confirmed_cases - COALESCE(LAG(confirmed_cases) OVER (PARTITION BY state_name ORDER BY date), 0) AS daily_new_cases
    FROM
        `bigquery-public-data.covid19_nyt.us_states`
    WHERE
        date BETWEEN '2020-03-01' AND '2020-05-31'
),
top5_states_per_day AS (
    SELECT
        date,
        state_name,
        daily_new_cases,
        DENSE_RANK() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS state_rank
    FROM
        state_daily_new_cases
    WHERE
        daily_new_cases > 0
),
state_top5_counts AS (
    SELECT
        state_name,
        COUNT(*) AS top5_appearance_count
    FROM
        top5_states_per_day
    WHERE
        state_rank <= 5
        AND daily_new_cases > 0
    GROUP BY
        state_name
),
state_ranking_with_rank AS (
    SELECT
        state_name,
        top5_appearance_count,
        DENSE_RANK() OVER (ORDER BY top5_appearance_count DESC) AS state_overall_rank
    FROM
        state_top5_counts
),
fourth_ranked_state AS (
    SELECT
        state_name
    FROM
        state_ranking_with_rank
    WHERE
        state_overall_rank = 4
    LIMIT 1
),
county_daily_new_cases AS (
    SELECT
        date,
        county,
        confirmed_cases,
        confirmed_cases - COALESCE(LAG(confirmed_cases) OVER (PARTITION BY county ORDER BY date), 0) AS daily_new_cases
    FROM
        `bigquery-public-data.covid19_nyt.us_counties`
    WHERE
        date BETWEEN '2020-03-01' AND '2020-05-31'
        AND state_name = (SELECT state_name FROM fourth_ranked_state)
),
top5_counties_per_day AS (
    SELECT
        date,
        county,
        daily_new_cases,
        DENSE_RANK() OVER (PARTITION BY date ORDER BY daily_new_cases DESC) AS county_rank
    FROM
        county_daily_new_cases
    WHERE
        daily_new_cases > 0
),
county_top5_counts AS (
    SELECT
        county,
        COUNT(*) AS top5_appearance_count
    FROM
        top5_counties_per_day
    WHERE
        county_rank <= 5
    GROUP BY
        county
)
SELECT
    county,
    top5_appearance_count AS count
FROM
    county_top5_counts
ORDER BY
    top5_appearance_count DESC
LIMIT 5;