WITH pm10 AS (
  SELECT 
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) AS pm10_avg
  FROM `bigquery-public-data.epa_historical_air_quality.pm10_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
pm25_frm AS (
  SELECT
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) AS pm25_frm_avg
  FROM `bigquery-public-data.epa_historical_air_quality.pm25_frm_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
pm25_non_frm AS (
  SELECT
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) AS pm25_non_frm_avg
  FROM `bigquery-public-data.epa_historical_air_quality.pm25_nonfrm_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
voc AS (
  SELECT
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) AS voc_avg
  FROM `bigquery-public-data.epa_historical_air_quality.voc_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
so2 AS (
  SELECT
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) * 10 AS so2_scaled_avg
  FROM `bigquery-public-data.epa_historical_air_quality.so2_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
lead AS (
  SELECT
    EXTRACT(MONTH FROM date_local) AS month_num,
    AVG(arithmetic_mean) * 100 AS lead_scaled_avg
  FROM `bigquery-public-data.epa_historical_air_quality.lead_daily_summary`
  WHERE state_name = 'California' AND EXTRACT(YEAR FROM date_local) = 2020
  GROUP BY month_num
),
month_table AS (
  SELECT 
    num AS month_num,
    FORMAT('%02d', num) AS month_num_formatted,
    CASE num
      WHEN 1 THEN 'Jan'
      WHEN 2 THEN 'Feb'
      WHEN 3 THEN 'Mar'
      WHEN 4 THEN 'Apr'
      WHEN 5 THEN 'May'
      WHEN 6 THEN 'Jun'
      WHEN 7 THEN 'Jul'
      WHEN 8 THEN 'Aug'
      WHEN 9 THEN 'Sep'
      WHEN 10 THEN 'Oct'
      WHEN 11 THEN 'Nov'
      WHEN 12 THEN 'Dec'
    END AS Month
  FROM UNNEST(GENERATE_ARRAY(1, 12)) AS num
)
SELECT
  mt.month_num_formatted AS Month_num,
  mt.Month,
  ROUND(pm10.pm10_avg, 4) AS PM10,
  ROUND(pm25_frm.pm25_frm_avg, 4) AS PM2_5_FRM,
  ROUND(pm25_non_frm.pm25_non_frm_avg, 4) AS PM2_5_non_FRM,
  ROUND(voc.voc_avg, 4) AS VOC,
  ROUND(so2.so2_scaled_avg, 4) AS SO2_scaled,
  ROUND(lead.lead_scaled_avg, 4) AS Lead_scaled
FROM month_table mt
LEFT JOIN pm10 ON mt.month_num = pm10.month_num
LEFT JOIN pm25_frm ON mt.month_num = pm25_frm.month_num
LEFT JOIN pm25_non_frm ON mt.month_num = pm25_non_frm.month_num
LEFT JOIN voc ON mt.month_num = voc.month_num
LEFT JOIN so2 ON mt.month_num = so2.month_num
LEFT JOIN lead ON mt.month_num = lead.month_num
ORDER BY mt.month_num;