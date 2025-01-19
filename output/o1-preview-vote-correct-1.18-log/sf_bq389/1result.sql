WITH pm10 AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM10_avg"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM10_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
pm25_frm AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM25_FRM_avg"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_FRM_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
pm25_nonfrm AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "PM25_nonFRM_avg"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_NONFRM_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
voc AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean"), 4) AS "VOC_avg"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."VOC_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
so2 AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean") * 10, 4) AS "SO2_avg_scaled_by_10"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."SO2_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
),
lead AS (
    SELECT
        EXTRACT(MONTH FROM "date_local") AS "Month_Number",
        ROUND(AVG("arithmetic_mean") * 100, 4) AS "Lead_avg_scaled_by_100"
    FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."LEAD_DAILY_SUMMARY"
    WHERE "state_name" = 'California' 
        AND EXTRACT(YEAR FROM "date_local") = 2020 
        AND "arithmetic_mean" IS NOT NULL
    GROUP BY EXTRACT(MONTH FROM "date_local")
)
SELECT
    TO_CHAR(DATE_FROM_PARTS(2020, pm10."Month_Number", 1), 'Mon') AS "Month",
    pm10."PM10_avg",
    pm25_frm."PM25_FRM_avg",
    pm25_nonfrm."PM25_nonFRM_avg",
    voc."VOC_avg",
    so2."SO2_avg_scaled_by_10",
    lead."Lead_avg_scaled_by_100"
FROM pm10
LEFT JOIN pm25_frm ON pm10."Month_Number" = pm25_frm."Month_Number"
LEFT JOIN pm25_nonfrm ON pm10."Month_Number" = pm25_nonfrm."Month_Number"
LEFT JOIN voc ON pm10."Month_Number" = voc."Month_Number"
LEFT JOIN so2 ON pm10."Month_Number" = so2."Month_Number"
LEFT JOIN lead ON pm10."Month_Number" = lead."Month_Number"
ORDER BY pm10."Month_Number";