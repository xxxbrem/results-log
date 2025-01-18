WITH months AS (
    SELECT 1 AS "Month_Num", 'Jan' AS "Month" UNION ALL
    SELECT 2 AS "Month_Num", 'Feb' AS "Month" UNION ALL
    SELECT 3 AS "Month_Num", 'Mar' AS "Month" UNION ALL
    SELECT 4 AS "Month_Num", 'Apr' AS "Month" UNION ALL
    SELECT 5 AS "Month_Num", 'May' AS "Month" UNION ALL
    SELECT 6 AS "Month_Num", 'Jun' AS "Month" UNION ALL
    SELECT 7 AS "Month_Num", 'Jul' AS "Month" UNION ALL
    SELECT 8 AS "Month_Num", 'Aug' AS "Month" UNION ALL
    SELECT 9 AS "Month_Num", 'Sep' AS "Month" UNION ALL
    SELECT 10 AS "Month_Num", 'Oct' AS "Month" UNION ALL
    SELECT 11 AS "Month_Num", 'Nov' AS "Month" UNION ALL
    SELECT 12 AS "Month_Num", 'Dec' AS "Month"
)
SELECT
    months."Month_Num",
    months."Month",
    pm10."PM10",
    pm25_frm."PM25_FRM",
    pm25_nonfrm."PM25_nonFRM",
    voc."VOC",
    so2."SO2_scaled_by_10",
    lead."Lead_scaled_by_100"
FROM
    months
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean"), 4) AS "PM10"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM10_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) pm10 ON months."Month_Num" = pm10."Month_Num"
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean"), 4) AS "PM25_FRM"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM25_FRM_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) pm25_frm ON months."Month_Num" = pm25_frm."Month_Num"
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean"), 4) AS "PM25_nonFRM"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.PM25_NONFRM_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) pm25_nonfrm ON months."Month_Num" = pm25_nonfrm."Month_Num"
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean"), 4) AS "VOC"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.VOC_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) voc ON months."Month_Num" = voc."Month_Num"
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean") * 10, 4) AS "SO2_scaled_by_10"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.SO2_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) so2 ON months."Month_Num" = so2."Month_Num"
    LEFT JOIN (
        SELECT
            EXTRACT(MONTH FROM "date_local") AS "Month_Num",
            ROUND(AVG("arithmetic_mean") * 100, 4) AS "Lead_scaled_by_100"
        FROM
            EPA_HISTORICAL_AIR_QUALITY.EPA_HISTORICAL_AIR_QUALITY.LEAD_DAILY_SUMMARY
        WHERE
            "state_name" = 'California' AND
            "date_local" BETWEEN '2020-01-01' AND '2020-12-31' AND
            "arithmetic_mean" IS NOT NULL
        GROUP BY
            "Month_Num"
    ) lead ON months."Month_Num" = lead."Month_Num"
ORDER BY
    months."Month_Num";