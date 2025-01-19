WITH
-- PM10 average per month
pm10 AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM10"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM10_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
-- PM2.5 FRM average per month
pm25_frm AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM25_FRM"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM25_FRM_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
-- PM2.5 non-FRM average per month
pm25_nonfrm AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM25_nonFRM"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM25_NONFRM_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
-- VOC average per month
voc AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "VOC"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.VOC_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
-- SO2 average per month, scaled by 10
so2 AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean") * 10, 4) AS "SO2_scaled"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.SO2_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
-- Lead average per month, scaled by 100
lead AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean") * 100, 4) AS "Lead_scaled"
    FROM EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.LEAD_DAILY_SUMMARY
    WHERE
        "state_code" = '06'
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
)

SELECT
    TO_CHAR(TO_DATE(months."Month_Number", 'MM'), 'Mon') AS "Month",
    pm10."PM10",
    pm25_frm."PM25_FRM",
    pm25_nonfrm."PM25_nonFRM",
    voc."VOC",
    so2."SO2_scaled",
    lead."Lead_scaled"
FROM (
    SELECT '1' AS "Month_Number" UNION ALL
    SELECT '2' UNION ALL
    SELECT '3' UNION ALL
    SELECT '4' UNION ALL
    SELECT '5' UNION ALL
    SELECT '6' UNION ALL
    SELECT '7' UNION ALL
    SELECT '8' UNION ALL
    SELECT '9' UNION ALL
    SELECT '10' UNION ALL
    SELECT '11' UNION ALL
    SELECT '12'
) months
LEFT JOIN pm10 ON months."Month_Number"::INT = pm10."Month_Number"
LEFT JOIN pm25_frm ON months."Month_Number"::INT = pm25_frm."Month_Number"
LEFT JOIN pm25_nonfrm ON months."Month_Number"::INT = pm25_nonfrm."Month_Number"
LEFT JOIN voc ON months."Month_Number"::INT = voc."Month_Number"
LEFT JOIN so2 ON months."Month_Number"::INT = so2."Month_Number"
LEFT JOIN lead ON months."Month_Number"::INT = lead."Month_Number"
ORDER BY months."Month_Number"::INT;