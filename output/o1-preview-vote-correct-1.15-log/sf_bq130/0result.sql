WITH state_daily_new_cases AS (
    SELECT
        S."date",
        S."state_name",
        S."confirmed_cases",
        S."confirmed_cases" - LAG(S."confirmed_cases") OVER (
            PARTITION BY S."state_name" ORDER BY S."date"
        ) AS daily_new_cases
    FROM COVID19_NYT.COVID19_NYT.US_STATES S
    WHERE S."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
state_daily_new_cases_filtered AS (
    SELECT
        "date",
        "state_name",
        CASE 
            WHEN daily_new_cases IS NULL THEN "confirmed_cases"
            WHEN daily_new_cases < 0 THEN 0
            ELSE daily_new_cases
        END AS daily_new_cases
    FROM state_daily_new_cases
),
state_daily_top5 AS (
    SELECT
        "date",
        "state_name",
        daily_new_cases,
        DENSE_RANK() OVER (PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST) AS rank
    FROM state_daily_new_cases_filtered
),
top5_states_per_day AS (
    SELECT
        "date",
        "state_name"
    FROM state_daily_top5
    WHERE rank <= 5
),
state_frequency AS (
    SELECT
        "state_name",
        COUNT(*) AS frequency
    FROM top5_states_per_day
    GROUP BY "state_name"
),
state_ranking AS (
    SELECT
        "state_name",
        frequency,
        RANK() OVER (ORDER BY frequency DESC NULLS LAST) AS state_rank
    FROM state_frequency
),
fourth_state AS (
    SELECT "state_name" FROM state_ranking WHERE state_rank = 4
),
county_daily_new_cases AS (
    SELECT
        C."date",
        C."county",
        C."confirmed_cases",
        C."confirmed_cases" - LAG(C."confirmed_cases") OVER (
            PARTITION BY C."county" ORDER BY C."date"
        ) AS daily_new_cases
    FROM COVID19_NYT.COVID19_NYT.US_COUNTIES C
    WHERE C."date" BETWEEN '2020-03-01' AND '2020-05-31'
      AND C."state_name" = (SELECT "state_name" FROM fourth_state)
),
county_daily_new_cases_filtered AS (
    SELECT
        "date",
        "county",
        CASE 
            WHEN daily_new_cases IS NULL THEN "confirmed_cases"
            WHEN daily_new_cases < 0 THEN 0
            ELSE daily_new_cases
        END AS daily_new_cases
    FROM county_daily_new_cases
),
county_daily_top5 AS (
    SELECT
        "date",
        "county",
        daily_new_cases,
        DENSE_RANK() OVER (PARTITION BY "date" ORDER BY daily_new_cases DESC NULLS LAST) AS rank
    FROM county_daily_new_cases_filtered
),
top5_counties_per_day AS (
    SELECT
        "date",
        "county"
    FROM county_daily_top5
    WHERE rank <= 5
),
county_frequency AS (
    SELECT
        "county" AS county_name,
        COUNT(*) AS frequency
    FROM top5_counties_per_day
    GROUP BY "county"
),
county_ranking AS (
    SELECT
        county_name,
        frequency
    FROM county_frequency
    ORDER BY frequency DESC NULLS LAST
    LIMIT 5
)
SELECT
    'After analyzing the daily new COVID-19 case counts from March to May 2020, we compiled a ranking of states based on how often each state appears in the daily top five increases. The state that ranks fourth overall is ' || (SELECT "state_name" FROM fourth_state) || '.\n\n' ||
    'Here are the top five counties in ' || (SELECT "state_name" FROM fourth_state) || ' based on their frequency of appearing in the daily top five new case counts:\n\n' ||
    'county_name,frequency\n' ||
    LISTAGG(county_name || ',' || frequency::VARCHAR, '\n') WITHIN GROUP (ORDER BY frequency DESC NULLS LAST)
    AS report
FROM county_ranking;