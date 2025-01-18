WITH monthly_data AS (
    SELECT
        EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) AS "Year",
        EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) AS "Month_Number",
        CASE 
            WHEN EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) = 4 THEN 'April'
            WHEN EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) = 5 THEN 'May'
            WHEN EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) = 6 THEN 'June'
        END AS "Month",
        COUNT(*) AS "Monthly_Total"
    FROM
        CITY_LEGISLATION.CITY_LEGISLATION.CITIES
    WHERE
        TRY_TO_DATE("insert_date", 'YYYY-MM-DD') IS NOT NULL
        AND EXTRACT(MONTH FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) BETWEEN 4 AND 6
        AND EXTRACT(YEAR FROM TRY_TO_DATE("insert_date", 'YYYY-MM-DD')) IN (2021, 2022, 2023)
    GROUP BY
        "Year", "Month_Number"
),
cumulative_data AS (
    SELECT
        "Year",
        "Month_Number",
        "Month",
        "Monthly_Total",
        SUM("Monthly_Total") OVER (PARTITION BY "Year" ORDER BY "Month_Number") AS "Cumulative_Total"
    FROM
        monthly_data
),
baseline_2021 AS (
    SELECT
        "Month_Number",
        "Monthly_Total" AS "Monthly_Total_2021",
        "Cumulative_Total" AS "Cumulative_Total_2021"
    FROM
        cumulative_data
    WHERE
        "Year" = 2021
),
yearly_data AS (
    SELECT
        "Year",
        "Month_Number",
        "Month",
        "Monthly_Total",
        "Cumulative_Total"
        FROM
            cumulative_data
        WHERE
            "Year" IN (2022, 2023)
    )
SELECT
    d."Year",
    d."Month",
    d."Monthly_Total" AS "Total_cities_added",
    d."Cumulative_Total" AS "Running_cumulative_total",
    TO_CHAR(ROUND( ((d."Monthly_Total" - b."Monthly_Total_2021") / b."Monthly_Total_2021") * 100, 4), 'FM999990.0000') || '%' AS "YoY_growth_percentage_monthly",
    TO_CHAR(ROUND( ((d."Cumulative_Total" - b."Cumulative_Total_2021") / b."Cumulative_Total_2021") * 100, 4), 'FM999990.0000') || '%' AS "YoY_growth_percentage_cumulative"
FROM
    yearly_data d
JOIN
    baseline_2021 b
ON
    d."Month_Number" = b."Month_Number"
ORDER BY
    d."Year",
    d."Month_Number";