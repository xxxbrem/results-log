WITH combined_data AS (
  SELECT t."date",
         t."trafficSource":source::STRING AS "Traffic_Source",
         ROUND((h.value:"product"::VARIANT[0]:"productRevenue")::FLOAT / 1000000, 4) AS "Product_Revenue_In_Millions"
  FROM (
    SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170101"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170102"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170103"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170104"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170105"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170106"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170107"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170108"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170109"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170110"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170111"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170112"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170113"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170114"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170115"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170116"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170117"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170118"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170119"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170120"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170121"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170122"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170123"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170124"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170125"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170126"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170127"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170128"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170129"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170130"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170131"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170201"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170202"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170203"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170204"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170205"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170206"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170207"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170208"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170209"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170210"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170211"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170212"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170213"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170214"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170215"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170216"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170217"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170218"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170219"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170220"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170221"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170222"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170223"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170224"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170225"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170226"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170227"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170228"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170301"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170302"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170303"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170304"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170305"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170306"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170307"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170308"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170309"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170310"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170311"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170312"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170313"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170314"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170315"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170316"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170317"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170318"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170319"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170320"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170321"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170322"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170323"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170324"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170325"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170326"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170327"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170328"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170329"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170330"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170331"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170401"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170402"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170403"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170404"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170405"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170406"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170407"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170408"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170409"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170410"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170411"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170412"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170413"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170414"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170415"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170416"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170417"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170418"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170419"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170420"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170421"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170422"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170423"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170424"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170425"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170426"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170427"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170428"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170429"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170430"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170501"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170502"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170503"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170504"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170505"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170506"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170507"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170508"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170509"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170510"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170511"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170512"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170513"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170514"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170515"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170516"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170517"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170518"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170519"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170520"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170521"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170522"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170523"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170524"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170525"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170526"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170527"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170528"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170529"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170530"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170531"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170601"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170602"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170603"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170604"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170605"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170606"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170607"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170608"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170609"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170610"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170611"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170612"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170613"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170614"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170615"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170616"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170617"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170618"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170619"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170620"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170621"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170622"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170623"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170624"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170625"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170626"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170627"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170628"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170629"
    UNION ALL SELECT * FROM "GA360"."GOOGLE_ANALYTICS_SAMPLE"."GA_SESSIONS_20170630"
  ) t,
  LATERAL FLATTEN(input => t."hits") h
  WHERE t."date" BETWEEN '20170101' AND '20170630'
    AND h.value:"product"::VARIANT[0]:"productRevenue" IS NOT NULL
),
top_traffic_source AS (
  SELECT "Traffic_Source",
         SUM("Product_Revenue_In_Millions") AS "Total_Product_Revenue"
  FROM combined_data
  GROUP BY "Traffic_Source"
  ORDER BY "Total_Product_Revenue" DESC NULLS LAST
  LIMIT 1
),
monthly_max AS (
  SELECT 'Monthly' AS "Time_Frame",
         TO_CHAR(DATE_TRUNC('MONTH', TO_DATE(cd."date", 'YYYYMMDD')), 'YYYY-MM') AS "Period",
         ROUND(SUM(cd."Product_Revenue_In_Millions"), 4) AS "Product_Revenue_In_Millions"
  FROM combined_data cd
  JOIN top_traffic_source tts ON cd."Traffic_Source" = tts."Traffic_Source"
  GROUP BY "Period"
  ORDER BY "Product_Revenue_In_Millions" DESC NULLS LAST
  LIMIT 1
),
weekly_max AS (
  SELECT 'Weekly' AS "Time_Frame",
         TO_CHAR(DATE_TRUNC('WEEK', TO_DATE(cd."date", 'YYYYMMDD')), 'YYYY-MM-DD') || ' to ' ||
         TO_CHAR(DATEADD('day', 6, DATE_TRUNC('WEEK', TO_DATE(cd."date", 'YYYYMMDD'))), 'YYYY-MM-DD') AS "Period",
         ROUND(SUM(cd."Product_Revenue_In_Millions"), 4) AS "Product_Revenue_In_Millions"
  FROM combined_data cd
  JOIN top_traffic_source tts ON cd."Traffic_Source" = tts."Traffic_Source"
  GROUP BY DATE_TRUNC('WEEK', TO_DATE(cd."date", 'YYYYMMDD'))
  ORDER BY "Product_Revenue_In_Millions" DESC NULLS LAST
  LIMIT 1
),
daily_max AS (
  SELECT 'Daily' AS "Time_Frame",
         TO_CHAR(TO_DATE(cd."date", 'YYYYMMDD'), 'YYYY-MM-DD') AS "Period",
         ROUND(SUM(cd."Product_Revenue_In_Millions"), 4) AS "Product_Revenue_In_Millions"
  FROM combined_data cd
  JOIN top_traffic_source tts ON cd."Traffic_Source" = tts."Traffic_Source"
  GROUP BY cd."date"
  ORDER BY "Product_Revenue_In_Millions" DESC NULLS LAST
  LIMIT 1
)
SELECT * FROM monthly_max
UNION ALL
SELECT * FROM weekly_max
UNION ALL
SELECT * FROM daily_max;