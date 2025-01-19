WITH months AS (
    SELECT '01' AS "Month_num", 'Jan' AS "Month"
    UNION ALL SELECT '02', 'Feb'
    UNION ALL SELECT '03', 'Mar'
    UNION ALL SELECT '04', 'Apr'
    UNION ALL SELECT '05', 'May'
    UNION ALL SELECT '06', 'Jun'
    UNION ALL SELECT '07', 'Jul'
    UNION ALL SELECT '08', 'Aug'
    UNION ALL SELECT '09', 'Sep'
    UNION ALL SELECT '10', 'Oct'
    UNION ALL SELECT '11', 'Nov'
    UNION ALL SELECT '12', 'Dec'
),
pm10 AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") AS "PM10_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM10_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
),
pm25_frm AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") AS "PM25_FRM_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_FRM_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
),
pm25_nonfrm AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") AS "PM25_Non_FRM_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_NONFRM_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
),
voc AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") AS "VOC_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."VOC_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
),
so2 AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") * 10 AS "SO2_Scaled_by_10_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."SO2_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
),
lead AS (
    SELECT
        TO_CHAR("date_local", 'MM') AS "Month_num",
        AVG("arithmetic_mean") * 100 AS "Lead_Scaled_by_100_avg"
    FROM
        "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."LEAD_DAILY_SUMMARY"
    WHERE
        "state_name" = 'California'            
        AND "date_local" BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY
        "Month_num"
)
SELECT
    months."Month_num",
    months."Month",
    ROUND(pm10."PM10_avg", 4) AS "PM10_avg",
    ROUND(pm25_frm."PM25_FRM_avg", 4) AS "PM25_FRM_avg",
    ROUND(pm25_nonfrm."PM25_Non_FRM_avg", 4) AS "PM25_Non_FRM_avg",
    ROUND(voc."VOC_avg", 4) AS "VOC_avg",
    ROUND(so2."SO2_Scaled_by_10_avg", 4) AS "SO2_Scaled_by_10_avg",
    ROUND(lead."Lead_Scaled_by_100_avg", 4) AS "Lead_Scaled_by_100_avg"
FROM
    months
LEFT JOIN pm10 ON months."Month_num" = pm10."Month_num"
LEFT JOIN pm25_frm ON months."Month_num" = pm25_frm."Month_num"
LEFT JOIN pm25_nonfrm ON months."Month_num" = pm25_nonfrm."Month_num"
LEFT JOIN voc ON months."Month_num" = voc."Month_num"
LEFT JOIN so2 ON months."Month_num" = so2."Month_num"
LEFT JOIN lead ON months."Month_num" = lead."Month_num"
ORDER BY
    months."Month_num";