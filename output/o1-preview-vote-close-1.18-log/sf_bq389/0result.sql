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
-- PM10 averages
pm10 AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") AS "PM10_avg"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM10_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
),
-- PM25_FRM averages
pm25f AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") AS "PM25_FRM_avg"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_FRM_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
),
-- PM25_NONFRM averages
pm25n AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") AS "PM25_NONFRM_avg"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_NONFRM_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
),
-- VOC averages
voc AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") AS "VOC_avg"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."VOC_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
),
-- SO2 averages (scaled by 10)
so2 AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") * 10 AS "SO2_avg_scaled"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."SO2_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
),
-- Lead averages (scaled by 100)
lead AS (
  SELECT
    TO_CHAR("date_local", 'MM') AS "Month_num",
    AVG("arithmetic_mean") * 100 AS "Lead_avg_scaled"
  FROM "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."LEAD_DAILY_SUMMARY"
  WHERE "state_name" = 'California'
    AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY "Month_num"
)
SELECT
  m."Month_num",
  m."Month",
  ROUND(pm10."PM10_avg", 4) AS "PM10_avg",
  ROUND(pm25f."PM25_FRM_avg", 4) AS "PM25_FRM_avg",
  ROUND(pm25n."PM25_NONFRM_avg", 4) AS "PM25_NONFRM_avg",
  ROUND(voc."VOC_avg", 4) AS "VOC_avg",
  ROUND(so2."SO2_avg_scaled", 4) AS "SO2_avg_scaled",
  ROUND(lead."Lead_avg_scaled", 4) AS "Lead_avg_scaled"
FROM months m
LEFT JOIN pm10 ON m."Month_num" = pm10."Month_num"
LEFT JOIN pm25f ON m."Month_num" = pm25f."Month_num"
LEFT JOIN pm25n ON m."Month_num" = pm25n."Month_num"
LEFT JOIN voc ON m."Month_num" = voc."Month_num"
LEFT JOIN so2 ON m."Month_num" = so2."Month_num"
LEFT JOIN lead ON m."Month_num" = lead."Month_num"
ORDER BY m."Month_num";