WITH daily_new_cases AS (
    SELECT S."date", S."state_name",
        GREATEST(S."confirmed_cases" - LAG(S."confirmed_cases") OVER (
            PARTITION BY S."state_name" ORDER BY S."date"
        ), 0) AS "new_cases"
    FROM COVID19_NYT.COVID19_NYT.US_STATES AS S
    WHERE S."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
daily_top5_states AS (
    SELECT "date", "state_name", "new_cases",
        RANK() OVER (
            PARTITION BY "date"
            ORDER BY "new_cases" DESC NULLS LAST
        ) AS rn
    FROM daily_new_cases
),
state_frequency AS (
    SELECT "state_name", COUNT(*) AS frequency
    FROM daily_top5_states
    WHERE rn <= 5
    GROUP BY "state_name"
),
state_ranking AS (
    SELECT "state_name", frequency,
        DENSE_RANK() OVER (
            ORDER BY frequency DESC NULLS LAST
        ) AS state_rank
    FROM state_frequency
),
fourth_state AS (
    SELECT "state_name"
    FROM state_ranking
    WHERE state_rank = 4
),
county_daily_new_cases AS (
    SELECT C."date", C."state_name", C."county",
        GREATEST(C."confirmed_cases" - LAG(C."confirmed_cases") OVER (
            PARTITION BY C."state_name", C."county" ORDER BY C."date"
        ), 0) AS "new_cases"
    FROM COVID19_NYT.COVID19_NYT.US_COUNTIES AS C
    INNER JOIN fourth_state AS FS ON C."state_name" = FS."state_name"
    WHERE C."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
county_daily_top5 AS (
    SELECT "date", "county", "new_cases",
        RANK() OVER (
            PARTITION BY "date"
            ORDER BY "new_cases" DESC NULLS LAST
        ) AS rn
    FROM county_daily_new_cases
),
county_frequency AS (
    SELECT "county" AS county_name, COUNT(*) AS frequency
    FROM county_daily_top5
    WHERE rn <= 5
    GROUP BY "county"
),
final_result AS (
    SELECT county_name, frequency
    FROM county_frequency
    ORDER BY frequency DESC NULLS LAST, county_name
    LIMIT 5
)
SELECT county_name, frequency
FROM final_result;