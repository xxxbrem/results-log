WITH
state_daily_cases AS (
    SELECT
        "date",
        "state_name",
        "confirmed_cases",
        "confirmed_cases" - COALESCE(LAG("confirmed_cases") OVER (PARTITION BY "state_name" ORDER BY "date"), 0) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_STATES
    WHERE
        "date" BETWEEN '2020-03-01' AND '2020-05-31'
),
daily_top_states AS (
    SELECT
        "date",
        "state_name",
        daily_new_cases,
        ROW_NUMBER() OVER (PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST) AS state_rank
    FROM
        state_daily_cases
),
state_frequency AS (
    SELECT
        "state_name",
        COUNT(*) AS frequency
    FROM
        daily_top_states
    WHERE
        state_rank <= 5
    GROUP BY
        "state_name"
),
ranked_states AS (
    SELECT
        "state_name",
        frequency,
        DENSE_RANK() OVER (ORDER BY frequency DESC NULLS LAST) AS state_rank
    FROM
        state_frequency
),
state_rank4 AS (
    SELECT
        "state_name"
    FROM
        ranked_states
    WHERE
        state_rank = 4
    LIMIT 1 -- In case of ties, pick one state
),
county_daily_cases AS (
    SELECT
        c."date",
        c."county",
        c."confirmed_cases",
        c."confirmed_cases" - COALESCE(LAG(c."confirmed_cases") OVER (PARTITION BY c."state_name", c."county" ORDER BY c."date"), 0) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_COUNTIES c
    WHERE
        c."state_name" = (SELECT "state_name" FROM state_rank4)
        AND c."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
daily_top_counties AS (
    SELECT
        "date",
        "county",
        daily_new_cases,
        ROW_NUMBER() OVER (PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST) AS county_rank
    FROM
        county_daily_cases
),
county_frequency AS (
    SELECT
        "county" AS county_name,
        COUNT(*) AS frequency
    FROM
        daily_top_counties
    WHERE
        county_rank <= 5
    GROUP BY
        "county"
),
ranked_counties AS (
    SELECT
        county_name,
        frequency
    FROM
        county_frequency
    ORDER BY
        frequency DESC NULLS LAST,
        county_name
    LIMIT 5
)
SELECT
    county_name,
    frequency
FROM
    ranked_counties;