SELECT
    vp."State",
    vp."Vulnerable_Population",
    mi."Average_Median_Income_Change"
FROM
    (
        SELECT
            sf."state" AS "State",
            sf."postal_code" AS "Postal_Code",
            ROUND(
                (
                    (s."employed_wholesale_trade" * 0.3842) +
                    ((s."employed_agriculture_forestry_fishing_hunting_mining" + s."employed_construction") * 0.4807) +
                    (s."employed_arts_entertainment_recreation_accommodation_food" * 0.8946) +
                    (s."employed_information" * 0.3132) +
                    (s."employed_retail_trade" * 0.51) +
                    (s."employed_public_administration" * 0.0393) +
                    (s."employed_other_services_not_public_admin" * 0.3656) +
                    (s."employed_education_health_social" * 0.2032) +
                    (s."employed_transportation_warehousing_utilities" * 0.3681) +
                    (s."employed_manufacturing" * 0.4062)
                ),
                4
            ) AS "Vulnerable_Population"
        FROM
            CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.STATE_2017_5YR s
        JOIN
            CENSUS_BUREAU_ACS_2.CYCLISTIC.STATE_FIPS sf
            ON s."geo_id" = LPAD(CAST(sf."fips" AS VARCHAR), 2, '0')
    ) vp
LEFT JOIN
    (
        SELECT
            zs."state_code" AS "Postal_Code",
            ROUND(AVG(ic."income_change"), 4) AS "Average_Median_Income_Change"
        FROM
            (
                SELECT
                    t2015."zip_code",
                    (t2018."median_income_2018" - t2015."median_income_2015") AS "income_change"
                FROM
                    (
                        SELECT "geo_id" AS "zip_code", "median_income" AS "median_income_2015"
                        FROM CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.ZIP_CODES_2015_5YR
                        WHERE "median_income" IS NOT NULL
                    ) t2015
                INNER JOIN
                    (
                        SELECT "geo_id" AS "zip_code", "median_income" AS "median_income_2018"
                        FROM CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.ZIP_CODES_2018_5YR
                        WHERE "median_income" IS NOT NULL
                    ) t2018
                ON t2015."zip_code" = t2018."zip_code"
            ) ic
        JOIN
            (
                SELECT DISTINCT "zip_code", "state_code"
                FROM CENSUS_BUREAU_ACS_2.GEO_US_BOUNDARIES.ZIP_CODES
            ) zs
        ON ic."zip_code" = zs."zip_code"
        GROUP BY
            zs."state_code"
    ) mi
ON vp."Postal_Code" = mi."Postal_Code"
ORDER BY
    vp."Vulnerable_Population" DESC NULLS LAST
LIMIT 10;