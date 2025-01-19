WITH daily_state_cases AS (
    SELECT
        S."date",
        S."state_name",
        COALESCE(
            S."confirmed_cases" - LAG(S."confirmed_cases") OVER (
                PARTITION BY S."state_name" ORDER BY S."date"
            ),
            S."confirmed_cases"
        ) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_STATES S
    WHERE
        S."date" >= '2020-03-01' AND S."date" <= '2020-05-31'
),
daily_state_ranks AS (
    SELECT
        D."date",
        D."state_name",
        D.daily_new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY D."date" ORDER BY D.daily_new_cases DESC NULLS LAST
        ) AS state_daily_rank
    FROM
        daily_state_cases D
),
state_top_fives AS (
    SELECT
        DR."state_name",
        COUNT(*) AS times_in_top_five
    FROM
        daily_state_ranks DR
    WHERE
        DR.state_daily_rank <= 5
    GROUP BY
        DR."state_name"
),
state_rankings AS (
    SELECT
        STF."state_name",
        STF.times_in_top_five,
        DENSE_RANK() OVER (
            ORDER BY STF.times_in_top_five DESC
        ) AS state_overall_rank
    FROM
        state_top_fives STF
),
selected_state AS (
    SELECT
        SR."state_name"
    FROM
        state_rankings SR
    WHERE
        SR.state_overall_rank = 4
),
daily_county_cases AS (
    SELECT
        C."date",
        C."state_name",
        C."county",
        COALESCE(
            C."confirmed_cases" - LAG(C."confirmed_cases") OVER (
                PARTITION BY C."state_name", C."county" ORDER BY C."date"
            ),
            C."confirmed_cases"
        ) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_COUNTIES C
    WHERE
        C."state_name" = (SELECT "state_name" FROM selected_state)
        AND C."date" >= '2020-03-01' AND C."date" <= '2020-05-31'
),
daily_county_ranks AS (
    SELECT
        DCC."date",
        DCC."state_name",
        DCC."county",
        DCC.daily_new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY DCC."date" ORDER BY DCC.daily_new_cases DESC NULLS LAST
        ) AS county_daily_rank
    FROM
        daily_county_cases DCC
),
county_top_fives AS (
    SELECT
        DCR."county",
        COUNT(*) AS times_in_top_five
    FROM
        daily_county_ranks DCR
    WHERE
        DCR.county_daily_rank <= 5
        AND DCR.daily_new_cases > 0
    GROUP BY
        DCR."county"
),
county_rankings AS (
    SELECT
        CTF."county" || ' County' AS "top_five_counties",
        CTF.times_in_top_five AS "count"
    FROM
        county_top_fives CTF
    ORDER BY
        CTF.times_in_top_five DESC NULLS LAST
    LIMIT 5
)
SELECT
    CR."top_five_counties",
    CR."count"
FROM
    county_rankings CR;