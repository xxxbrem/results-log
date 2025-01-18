WITH MONTHS AS (
  SELECT ROW_NUMBER() OVER (ORDER BY seq4()) AS "Month_num"
  FROM TABLE(GENERATOR(ROWCOUNT => 12))
),
PM10_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") AS "PM10_avg"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM10_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
),
PM25_FRM_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") AS "PM25_FRM_avg"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_FRM_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
),
PM25_NONFRM_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") AS "PM25_nonFRM_avg"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."PM25_NONFRM_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
),
VOC_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") AS "VOC_avg"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."VOC_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
),
SO2_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") * 10 AS "SO2_avg_10x"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."SO2_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
),
LEAD_DATA AS (
  SELECT
    EXTRACT(MONTH FROM "date_local") AS "Month_num",
    AVG("arithmetic_mean") * 100 AS "Lead_avg_100x"
  FROM
    "EPA_HISTORICAL_AIR_QUALITY"."EPA_HISTORICAL_AIR_QUALITY"."LEAD_DAILY_SUMMARY"
  WHERE
    "state_name" = 'California' AND EXTRACT(YEAR FROM "date_local") = 2020
  GROUP BY
    EXTRACT(MONTH FROM "date_local")
)

SELECT
  LPAD(MONTHS."Month_num", 2, '0') AS "Month_num",
  TO_CHAR(DATEADD(MONTH, MONTHS."Month_num" - 1, TO_DATE('2020-01-01')), 'Mon') AS "Month",
  ROUND(PM10_DATA."PM10_avg", 4) AS "PM10_avg",
  ROUND(PM25_FRM_DATA."PM25_FRM_avg", 4) AS "PM25_FRM_avg",
  ROUND(PM25_NONFRM_DATA."PM25_nonFRM_avg", 4) AS "PM25_nonFRM_avg",
  ROUND(VOC_DATA."VOC_avg", 4) AS "VOC_avg",
  ROUND(SO2_DATA."SO2_avg_10x", 4) AS "SO2_avg_10x",
  ROUND(LEAD_DATA."Lead_avg_100x", 4) AS "Lead_avg_100x"
FROM
  MONTHS
LEFT JOIN PM10_DATA ON MONTHS."Month_num" = PM10_DATA."Month_num"
LEFT JOIN PM25_FRM_DATA ON MONTHS."Month_num" = PM25_FRM_DATA."Month_num"
LEFT JOIN PM25_NONFRM_DATA ON MONTHS."Month_num" = PM25_NONFRM_DATA."Month_num"
LEFT JOIN VOC_DATA ON MONTHS."Month_num" = VOC_DATA."Month_num"
LEFT JOIN SO2_DATA ON MONTHS."Month_num" = SO2_DATA."Month_num"
LEFT JOIN LEAD_DATA ON MONTHS."Month_num" = LEAD_DATA."Month_num"
ORDER BY MONTHS."Month_num";