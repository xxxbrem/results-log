WITH StateDailyNewCases AS (
    SELECT
        S."date",
        S."state_name",
        S."confirmed_cases",
        LAG(S."confirmed_cases") OVER (
            PARTITION BY S."state_name"
            ORDER BY S."date"
        ) AS prev_confirmed_cases,
        (S."confirmed_cases" - LAG(S."confirmed_cases") OVER (
            PARTITION BY S."state_name"
            ORDER BY S."date"
        )) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_STATES S
    WHERE
        S."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
RankedStateDailyNewCases AS (
    SELECT
        SDNC."date",
        SDNC."state_name",
        COALESCE(SDNC.daily_new_cases, 0) AS daily_new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY SDNC."date"
            ORDER BY COALESCE(SDNC.daily_new_cases, 0) DESC NULLS LAST
        ) AS rank
    FROM
        StateDailyNewCases SDNC
),
Top5StatesPerDay AS (
    SELECT
        RSDNC."date",
        RSDNC."state_name",
        RSDNC.daily_new_cases
    FROM
        RankedStateDailyNewCases RSDNC
    WHERE
        RSDNC.rank <= 5
),
StateRankings AS (
    SELECT
        TSPD."state_name",
        COUNT(*) AS appearance_count,
        DENSE_RANK() OVER (
            ORDER BY COUNT(*) DESC NULLS LAST
        ) AS overall_rank
    FROM
        Top5StatesPerDay TSPD
    GROUP BY
        TSPD."state_name"
),
FourthRankedState AS (
    SELECT
        SR."state_name"
    FROM
        StateRankings SR
    WHERE
        SR.overall_rank = 4
),
CountyDailyNewCases AS (
    SELECT
        C."date",
        C."county",
        C."state_name",
        C."confirmed_cases",
        LAG(C."confirmed_cases") OVER (
            PARTITION BY C."state_name", C."county"
            ORDER BY C."date"
        ) AS prev_confirmed_cases,
        (C."confirmed_cases" - LAG(C."confirmed_cases") OVER (
            PARTITION BY C."state_name", C."county"
            ORDER BY C."date"
        )) AS daily_new_cases
    FROM
        COVID19_NYT.COVID19_NYT.US_COUNTIES C
    WHERE
        C."date" BETWEEN '2020-03-01' AND '2020-05-31'
),
CountiesInFourthState AS (
    SELECT
        CDNC.*
    FROM
        CountyDailyNewCases CDNC
        INNER JOIN FourthRankedState FRS ON CDNC."state_name" = FRS."state_name"
),
RankedCountyDailyNewCases AS (
    SELECT
        CID."date",
        CID."county",
        COALESCE(CID.daily_new_cases, 0) AS daily_new_cases,
        ROW_NUMBER() OVER (
            PARTITION BY CID."date"
            ORDER BY COALESCE(CID.daily_new_cases, 0) DESC NULLS LAST
        ) AS rank
    FROM
        CountiesInFourthState CID
),
Top5CountiesPerDay AS (
    SELECT
        RCDNC."date",
        RCDNC."county",
        RCDNC.daily_new_cases
    FROM
        RankedCountyDailyNewCases RCDNC
    WHERE
        RCDNC.rank <= 5
),
CountyRankings AS (
    SELECT
        TCDPD."county" AS county_name,
        COUNT(*) AS appearance_count
    FROM
        Top5CountiesPerDay TCDPD
    GROUP BY
        TCDPD."county"
    ORDER BY
        appearance_count DESC NULLS LAST,
        county_name ASC
)
SELECT
    CR.county_name,
    CR.appearance_count
FROM
    CountyRankings CR
LIMIT 5;