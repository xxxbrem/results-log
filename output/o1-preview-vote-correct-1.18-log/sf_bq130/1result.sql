WITH
DAILY_NEW_CASES_PER_STATE AS (
    SELECT
        S."date",
        S."state_name",
        S."confirmed_cases",
        COALESCE(S."confirmed_cases" - LAG(S."confirmed_cases") OVER (
            PARTITION BY S."state_name" 
            ORDER BY S."date"
        ), S."confirmed_cases") AS "daily_new_cases"
    FROM
        "COVID19_NYT"."COVID19_NYT"."US_STATES" AS S
    WHERE 
        S."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
TOP_STATES_PER_DAY AS (
    SELECT
        D."date",
        D."state_name",
        D."daily_new_cases",
        ROW_NUMBER() OVER (
            PARTITION BY D."date"
            ORDER BY D."daily_new_cases" DESC NULLS LAST, D."state_name"
        ) AS state_rank
    FROM
        DAILY_NEW_CASES_PER_STATE AS D
),
TOP_STATES_COUNTER AS (
    SELECT 
        "state_name", 
        COUNT(*) AS frequency
    FROM
        TOP_STATES_PER_DAY
    WHERE state_rank <=5
    GROUP BY "state_name"
),
STATES_RANKING AS (
    SELECT
        T."state_name",
        T.frequency,
        RANK() OVER (ORDER BY T.frequency DESC NULLS LAST, T."state_name") AS overall_rank
    FROM
        TOP_STATES_COUNTER AS T
),
STATE_RANKED_FOURTH AS (
    SELECT
        S."state_name"
    FROM
        STATES_RANKING AS S
    WHERE
        S.overall_rank = 4
),
DAILY_NEW_CASES_PER_COUNTY AS (
    SELECT
        C."date",
        C."county",
        C."state_name",
        C."confirmed_cases",
        COALESCE(C."confirmed_cases" - LAG(C."confirmed_cases") OVER (
            PARTITION BY C."county" 
            ORDER BY C."date"
        ), C."confirmed_cases") AS "daily_new_cases"
    FROM
        "COVID19_NYT"."COVID19_NYT"."US_COUNTIES" AS C
    WHERE
        C."date" BETWEEN '2020-03-01' AND '2020-05-31'
        AND C."state_name" = (SELECT "state_name" FROM STATE_RANKED_FOURTH)
),
TOP_COUNTIES_PER_DAY AS (
    SELECT
        D."date",
        D."county",
        D."daily_new_cases",
        ROW_NUMBER() OVER (
            PARTITION BY D."date"
            ORDER BY D."daily_new_cases" DESC NULLS LAST, D."county"
        ) AS county_rank
    FROM 
        DAILY_NEW_CASES_PER_COUNTY AS D
),
TOP_COUNTIES_COUNTER AS (
    SELECT 
        "county", 
        COUNT(*) AS frequency
    FROM
        TOP_COUNTIES_PER_DAY
    WHERE county_rank <=5
    GROUP BY "county"
)
SELECT
    T."county" AS County_name,
    T.frequency AS Frequency
FROM
    TOP_COUNTIES_COUNTER AS T
ORDER BY
    T.frequency DESC NULLS LAST, T."county"
LIMIT 5;