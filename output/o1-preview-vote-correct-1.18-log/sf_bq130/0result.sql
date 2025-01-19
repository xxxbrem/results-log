WITH cte_state_daily AS (
    SELECT
        "date",
        "state_name",
        CASE
            WHEN "confirmed_cases" - LAG("confirmed_cases") OVER (PARTITION BY "state_name" ORDER BY "date") >= 0 THEN
                "confirmed_cases" - LAG("confirmed_cases") OVER (PARTITION BY "state_name" ORDER BY "date")
            ELSE 0
        END AS "daily_new_cases"
    FROM
        "COVID19_NYT"."COVID19_NYT"."US_STATES"
    WHERE
        "date" BETWEEN '2020-03-01' AND '2020-05-31'
),
cte_state_daily_ranks AS (
    SELECT
        "date",
        "state_name",
        "daily_new_cases",
        ROW_NUMBER() OVER (PARTITION BY "date" ORDER BY "daily_new_cases" DESC NULLS LAST) AS rank
    FROM
        cte_state_daily
),
cte_state_top5 AS (
    SELECT
        "date",
        "state_name"
    FROM
        cte_state_daily_ranks
    WHERE
        rank <= 5
),
cte_state_rankings AS (
    SELECT
        "state_name",
        COUNT(*) AS appearances
    FROM
        cte_state_top5
    GROUP BY
        "state_name"
),
cte_state_overall_rank AS (
    SELECT
        "state_name",
        appearances,
        DENSE_RANK() OVER (ORDER BY appearances DESC) AS state_rank
    FROM
        cte_state_rankings
),
cte_fourth_state AS (
    SELECT "state_name"
    FROM cte_state_overall_rank
    WHERE state_rank = 4
),
cte_county_daily AS (
    SELECT
        USC."date",
        USC."state_name",
        USC."county",
        CASE
            WHEN USC."confirmed_cases" - LAG(USC."confirmed_cases") OVER (PARTITION BY USC."state_name", USC."county" ORDER BY USC."date") >= 0 THEN
                USC."confirmed_cases" - LAG(USC."confirmed_cases") OVER (PARTITION BY USC."state_name", USC."county" ORDER BY USC."date")
            ELSE 0
        END AS "daily_new_cases"
    FROM
        "COVID19_NYT"."COVID19_NYT"."US_COUNTIES" USC
    WHERE
        USC."date" BETWEEN '2020-03-01' AND '2020-05-31'
        AND USC."state_name" IN (SELECT "state_name" FROM cte_fourth_state)
),
cte_county_daily_ranks AS (
    SELECT
        "date",
        "county",
        "state_name",
        "daily_new_cases",
        ROW_NUMBER() OVER (PARTITION BY "date" ORDER BY "daily_new_cases" DESC NULLS LAST) AS rank
    FROM
        cte_county_daily
),
cte_county_top5 AS (
    SELECT
        "county"
    FROM
        cte_county_daily_ranks
    WHERE
        rank <= 5
),
cte_county_rankings AS (
    SELECT
        "county",
        COUNT(*) AS count
    FROM
        cte_county_top5
    GROUP BY
        "county"
    ORDER BY
        count DESC
),
top_five_counties AS (
    SELECT
        "county",
        count
    FROM
        cte_county_rankings
    ORDER BY
        count DESC
    LIMIT 5
)
SELECT
    "county" AS "top_five_counties",
    count
FROM
    top_five_counties;