WITH monthly_totals AS (
    SELECT
        EXTRACT(YEAR FROM TO_DATE("insert_date", 'YYYY-MM-DD')) AS "Year",
        EXTRACT(MONTH FROM TO_DATE("insert_date", 'YYYY-MM-DD')) AS "Month_Num",
        COUNT(*) AS "Total_Cities"
    FROM "CITY_LEGISLATION"."CITY_LEGISLATION"."CITIES"
    WHERE
        TO_DATE("insert_date", 'YYYY-MM-DD') IS NOT NULL
        AND EXTRACT(MONTH FROM TO_DATE("insert_date", 'YYYY-MM-DD')) IN (4, 5, 6)
        AND EXTRACT(YEAR FROM TO_DATE("insert_date", 'YYYY-MM-DD')) BETWEEN 2021 AND 2023
    GROUP BY 1, 2
    ORDER BY "Year", "Month_Num"
),
cumulative_totals AS (
    SELECT
        "Year",
        "Month_Num",
        "Total_Cities",
        SUM("Total_Cities") OVER (PARTITION BY "Year" ORDER BY "Month_Num") AS "Running_Cumulative_Total"
    FROM monthly_totals
),
joined_totals AS (
    SELECT
        ct1."Year",
        ct1."Month_Num",
        ct1."Total_Cities",
        ct1."Running_Cumulative_Total",
        ct2."Total_Cities" AS "Prev_Year_Total_Cities",
        ct2."Running_Cumulative_Total" AS "Prev_Year_Running_Cumulative_Total"
    FROM cumulative_totals ct1
    LEFT JOIN cumulative_totals ct2
        ON ct1."Year" = ct2."Year" + 1
        AND ct1."Month_Num" = ct2."Month_Num"
)
SELECT
    CAST("Year" AS VARCHAR) AS "Year",
    CASE "Month_Num"
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
    END AS "Month",
    "Total_Cities" AS "Total number of cities added",
    "Running_Cumulative_Total" AS "Running cumulative total",
    CASE
        WHEN "Prev_Year_Total_Cities" IS NOT NULL AND "Prev_Year_Total_Cities" != 0 THEN
            TO_CHAR(ROUND((("Total_Cities" - "Prev_Year_Total_Cities") / "Prev_Year_Total_Cities") * 100, 4)) || '%'
        ELSE
            'N/A'
    END AS "Year-over-year growth percentage for monthly total (%)",
    CASE
        WHEN "Prev_Year_Running_Cumulative_Total" IS NOT NULL AND "Prev_Year_Running_Cumulative_Total" != 0 THEN
            TO_CHAR(ROUND((("Running_Cumulative_Total" - "Prev_Year_Running_Cumulative_Total") / "Prev_Year_Running_Cumulative_Total") * 100, 4)) || '%'
        ELSE
            'N/A'
    END AS "Year-over-year growth percentage for running total (%)"
FROM joined_totals
WHERE "Year" > 2021
ORDER BY "Year", "Month_Num";