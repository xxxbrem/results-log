WITH
Baseline_Monthly AS (
    SELECT
        EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) AS "MonthNumber",
        COUNT(*) AS "Baseline_Monthly_Total"
    FROM
        CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE
        EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) = 2021
        AND EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) BETWEEN 4 AND 6
    GROUP BY
        EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD'))
),
Baseline AS (
    SELECT
        "MonthNumber",
        "Baseline_Monthly_Total",
        SUM("Baseline_Monthly_Total") OVER (ORDER BY "MonthNumber") AS "Baseline_Cumulative_Total"
    FROM
        Baseline_Monthly
),
Data_Monthly AS (
    SELECT
        EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) AS "Year",
        EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) AS "MonthNumber",
        COUNT(*) AS "Monthly_Total"
    FROM
        CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE
        EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) IN (2022, 2023)
        AND EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) BETWEEN 4 AND 6
    GROUP BY
        EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')),
        EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD'))
),
Data_Cumulative AS (
    SELECT
        "Year",
        "MonthNumber",
        "Monthly_Total",
        SUM("Monthly_Total") OVER (PARTITION BY "Year" ORDER BY "MonthNumber") AS "Cumulative_Total"
    FROM
        Data_Monthly
),
Final_Data AS (
    SELECT
        d."Year",
        d."MonthNumber",
        d."Monthly_Total",
        d."Cumulative_Total",
        b."Baseline_Monthly_Total",
        b."Baseline_Cumulative_Total",
        CONCAT(ROUND(((d."Monthly_Total" - b."Baseline_Monthly_Total") / NULLIF(b."Baseline_Monthly_Total", 0)) * 100, 4), '%') AS "Monthly Growth Percentage",
        CONCAT(ROUND(((d."Cumulative_Total" - b."Baseline_Cumulative_Total") / NULLIF(b."Baseline_Cumulative_Total", 0)) * 100, 4), '%') AS "Cumulative Growth Percentage"
    FROM
        Data_Cumulative d
        JOIN Baseline b ON d."MonthNumber" = b."MonthNumber"
)
SELECT
    "Year",
    CASE "MonthNumber"
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
    END AS "Month",
    "Monthly_Total" AS "Total Cities Added",
    "Cumulative_Total" AS "Running Cumulative Total",
    "Monthly Growth Percentage",
    "Cumulative Growth Percentage"
FROM
    Final_Data
ORDER BY
    "Year", "MonthNumber";