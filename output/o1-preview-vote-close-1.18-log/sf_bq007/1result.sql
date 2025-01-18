WITH state_employment AS (
    SELECT 
        s."geo_id" AS "state_fips_code",
        (
            s."employed_wholesale_trade" * 0.38423645320197042 +
            s."employed_arts_entertainment_recreation_accommodation_food" * 0.89455676291236841 +
            s."employed_information" * 0.31315240083507306 +
            s."employed_retail_trade" * 0.51 +
            s."employed_public_administration" * 0.039299298394228743 +
            s."employed_other_services_not_public_admin" * 0.36555534476489654 +
            s."employed_education_health_social" * 0.20323178400562944 +
            s."employed_transportation_warehousing_utilities" * 0.3680506593618087 +
            s."employed_manufacturing" * 0.40618955512572535 +
            s."occupation_natural_resources_construction_maintenance" * 0.48071410777129553
        ) AS "vulnerable_population"
    FROM CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.STATE_2017_5YR s
),
state_names AS (
    SELECT
        LPAD(s."fips", 2, '0') AS "state_fips_code",
        s."state" AS "State",
        UPPER(TRIM(s."postal_code")) AS "state_code"
    FROM CENSUS_BUREAU_ACS_2.CYCLISTIC.STATE_FIPS s
),
state_income_changes AS (
    SELECT
        sn."state_fips_code",
        ROUND(AVG(z."income_change"), 4) AS "average_median_income_change"
    FROM (
        SELECT
            z2015."geo_id" AS "zip_code",
            z2018."median_income" - z2015."median_income" AS "income_change"
        FROM
            CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.ZIP_CODES_2015_5YR z2015
        JOIN
            CENSUS_BUREAU_ACS_2.CENSUS_BUREAU_ACS.ZIP_CODES_2018_5YR z2018
                ON z2015."geo_id" = z2018."geo_id"
        WHERE z2015."median_income" IS NOT NULL AND z2018."median_income" IS NOT NULL
    ) z
    JOIN (
        SELECT
            TRIM(gz."zip_code") AS "zip_code",
            UPPER(TRIM(gz."state_code")) AS "state_code"
        FROM CENSUS_BUREAU_ACS_2.GEO_US_BOUNDARIES.ZIP_CODES gz
    ) gz
        ON z."zip_code" = gz."zip_code"
    JOIN state_names sn
        ON gz."state_code" = sn."state_code"
    GROUP BY sn."state_fips_code"
)
SELECT
    sn."State",
    ROUND(se."vulnerable_population", 4) AS "Vulnerable_Population",
    sic."average_median_income_change" AS "Average_Median_Income_Change"
FROM
    state_employment se
JOIN
    state_names sn
    ON se."state_fips_code" = sn."state_fips_code"
LEFT JOIN
    state_income_changes sic
    ON se."state_fips_code" = sic."state_fips_code"
ORDER BY
    se."vulnerable_population" DESC NULLS LAST
LIMIT 10;