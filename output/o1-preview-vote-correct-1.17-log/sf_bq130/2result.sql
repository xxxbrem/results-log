WITH state_new_cases AS (
    SELECT
        s."date",
        s."state_name",
        s."confirmed_cases" AS cumulative_cases,
        LAG(s."confirmed_cases") OVER (
            PARTITION BY s."state_name"
            ORDER BY s."date"
        ) AS previous_cumulative_cases,
        s."confirmed_cases" - LAG(s."confirmed_cases") OVER (
            PARTITION BY s."state_name"
            ORDER BY s."date"
        ) AS new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_STATES s
    WHERE
        s."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
daily_top_states AS (
    SELECT
        state_new_cases."date",
        state_new_cases."state_name",
        state_new_cases.new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY state_new_cases."date"
            ORDER BY state_new_cases.new_cases DESC NULLS LAST
        ) AS state_rank
    FROM
        state_new_cases
),
state_top_counts AS (
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
        ROW_NUMBER() OVER (
            ORDER BY frequency DESC
        ) AS state_overall_rank
    FROM
        state_top_counts
),
fourth_state AS (
    SELECT
        "state_name"
    FROM
        ranked_states
    WHERE
        state_overall_rank = 4
),
county_new_cases AS (
    SELECT
        c."date",
        c."county",
        c."confirmed_cases" AS cumulative_cases,
        LAG(c."confirmed_cases") OVER (
            PARTITION BY c."county"
            ORDER BY c."date"
        ) AS previous_cumulative_cases,
        c."confirmed_cases" - LAG(c."confirmed_cases") OVER (
            PARTITION BY c."county"
            ORDER BY c."date"
        ) AS new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_COUNTIES c
    WHERE
        c."date" BETWEEN '2020-03-01' AND '2020-05-31'
        AND c."state_name" = (SELECT "state_name" FROM fourth_state)
),
daily_top_counties AS (
    SELECT
        county_new_cases."date",
        county_new_cases."county",
        county_new_cases.new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY county_new_cases."date"
            ORDER BY county_new_cases.new_cases DESC NULLS LAST
        ) AS county_rank
    FROM
        county_new_cases
),
county_top_counts AS (
    SELECT
        "county",
        COUNT(*) AS frequency
    FROM
        daily_top_counties
    WHERE
        county_rank <= 5
    GROUP BY
        "county"
)
SELECT
    CASE
        WHEN "county" ILIKE '%County' THEN "county"
        ELSE CONCAT("county", ' County')
    END AS county_name,
    frequency
FROM
    county_top_counts
ORDER BY
    frequency DESC NULLS LAST,
    "county"
LIMIT 5;