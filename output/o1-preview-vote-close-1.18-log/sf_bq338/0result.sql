WITH tract_data AS (
    SELECT
        t2011."geo_id" AS "Tract_Code",
        t2018."total_pop" - t2011."total_pop" AS "Population_Increase",
        t2018."median_income" - t2011."median_income" AS "Median_Income_Increase",
        t2011."total_pop" AS "Total_Pop_2011",
        t2018."total_pop" AS "Total_Pop_2018",
        t2011."median_income" AS "Median_Income_2011",
        t2018."median_income" AS "Median_Income_2018"
    FROM
        "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2011_5YR" AS t2011
        JOIN
        "CENSUS_BUREAU_ACS_1"."CENSUS_BUREAU_ACS"."CENSUSTRACT_2018_5YR" AS t2018
        ON t2011."geo_id" = t2018."geo_id"
    WHERE
        t2011."geo_id" LIKE '36047%'
        AND t2011."total_pop" > 1000
        AND t2018."total_pop" > 1000
        AND t2011."median_income" IS NOT NULL
        AND t2018."median_income" IS NOT NULL
),
ranked_data AS (
    SELECT
        tract_data.*,
        RANK() OVER (ORDER BY tract_data."Population_Increase" DESC NULLS LAST) AS "Pop_Rank",
        RANK() OVER (ORDER BY tract_data."Median_Income_Increase" DESC NULLS LAST) AS "Income_Rank"
    FROM
        tract_data
)
SELECT
    "Tract_Code",
    ROUND("Population_Increase", 4) AS "Population_Increase",
    ROUND("Median_Income_Increase", 4) AS "Median_Income_Increase"
FROM
    ranked_data
WHERE
    "Pop_Rank" <= 20
    AND "Income_Rank" <= 20
ORDER BY
    "Population_Increase" DESC NULLS LAST,
    "Median_Income_Increase" DESC NULLS LAST;