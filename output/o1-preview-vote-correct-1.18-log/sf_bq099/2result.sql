WITH
AssigneeData AS (
    SELECT
        assignee_f.value::VARIANT:"name"::STRING AS "Assignee_Name",
        SUBSTRING(CAST(t."filing_date" AS VARCHAR), 1, 4) AS "Filing_Year",
        t."country_code" AS "Country_Code",
        t."publication_number" AS "Publication_Number"
    FROM
        PATENTS.PATENTS.PUBLICATIONS t,
        LATERAL FLATTEN(input => t."ipc") ipc_f,
        LATERAL FLATTEN(input => t."assignee_harmonized") assignee_f
    WHERE
        ipc_f.value::VARIANT:"code"::STRING LIKE 'A01B3%'
        AND assignee_f.value::VARIANT:"name"::STRING IS NOT NULL
        AND t."filing_date" IS NOT NULL
),
AssigneeTotals AS (
    SELECT
        "Assignee_Name",
        COUNT(DISTINCT "Publication_Number") AS "Total_Applications"
    FROM
        AssigneeData
    GROUP BY
        "Assignee_Name"
),
AssigneeTop3 AS (
    SELECT
        "Assignee_Name",
        "Total_Applications"
    FROM
        AssigneeTotals
    ORDER BY
        "Total_Applications" DESC NULLS LAST,
        "Assignee_Name" ASC
    LIMIT 3
),
AssigneeYearCounts AS (
    SELECT
        "Assignee_Name",
        "Filing_Year",
        COUNT(DISTINCT "Publication_Number") AS "Applications_in_Year"
    FROM
        AssigneeData
    GROUP BY
        "Assignee_Name", "Filing_Year"
),
AssigneePeakYears AS (
    SELECT
        AYC."Assignee_Name",
        AYC."Filing_Year" AS "Year_with_Most_Applications",
        AYC."Applications_in_Year",
        ROW_NUMBER() OVER (
            PARTITION BY AYC."Assignee_Name"
            ORDER BY AYC."Applications_in_Year" DESC NULLS LAST, AYC."Filing_Year" ASC
        ) AS RN
    FROM
        AssigneeYearCounts AYC
        INNER JOIN AssigneeTop3 AT3
            ON AYC."Assignee_Name" = AT3."Assignee_Name"
),
AssigneePeakYear AS (
    SELECT
        "Assignee_Name",
        "Year_with_Most_Applications",
        "Applications_in_Year" AS "Applications_in_That_Year"
    FROM
        AssigneePeakYears
    WHERE
        RN = 1
),
AssigneeCountryCounts AS (
    SELECT
        AD."Assignee_Name",
        AD."Country_Code",
        COUNT(DISTINCT AD."Publication_Number") AS "Applications_in_Country"
    FROM
        AssigneeData AD
        INNER JOIN AssigneePeakYear APY
            ON AD."Assignee_Name" = APY."Assignee_Name"
            AND AD."Filing_Year" = APY."Year_with_Most_Applications"
    GROUP BY
        AD."Assignee_Name",
        AD."Country_Code"
),
AssigneePeakCountries AS (
    SELECT
        ACC."Assignee_Name",
        ACC."Country_Code" AS "Country_Code_with_Most_Applications",
        ACC."Applications_in_Country",
        ROW_NUMBER() OVER (
            PARTITION BY ACC."Assignee_Name"
            ORDER BY ACC."Applications_in_Country" DESC NULLS LAST, ACC."Country_Code" ASC
        ) AS RN
    FROM
        AssigneeCountryCounts ACC
),
AssigneePeakCountry AS (
    SELECT
        "Assignee_Name",
        "Country_Code_with_Most_Applications"
    FROM
        AssigneePeakCountries
    WHERE
        RN = 1
)
SELECT
    AT3."Assignee_Name",
    AT3."Total_Applications",
    APY."Year_with_Most_Applications",
    APY."Applications_in_That_Year",
    APC."Country_Code_with_Most_Applications"
FROM
    AssigneeTop3 AT3
    INNER JOIN AssigneePeakYear APY
        ON AT3."Assignee_Name" = APY."Assignee_Name"
    INNER JOIN AssigneePeakCountry APC
        ON AT3."Assignee_Name" = APC."Assignee_Name"
ORDER BY
    AT3."Total_Applications" DESC NULLS LAST,
    AT3."Assignee_Name" ASC;