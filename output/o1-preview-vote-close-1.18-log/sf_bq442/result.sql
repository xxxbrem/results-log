SELECT
   t."TradeReportID" AS "tradeID",
   TO_TIMESTAMP_NTZ(t."MaturityDate" / 1000000) AS "tradeTimestamp",
   CASE 
     WHEN LEFT(t."TargetCompID", 4) = 'MOMO' THEN 'Momentum'
     WHEN LEFT(t."TargetCompID", 4) = 'LUCK' THEN 'Feeling Lucky'
     WHEN LEFT(t."TargetCompID", 4) = 'PRED' THEN 'Prediction'
     ELSE 'Unknown'
   END AS "algorithm",
   t."Symbol" AS "symbol",
   ROUND(t."LastPx", 4) AS "openPrice",
   ROUND(t."StrikePrice", 4) AS "closePrice",
   f.VALUE:"Side"::STRING AS "tradeDirection",
   CASE 
     WHEN f.VALUE:"Side"::STRING = 'SHORT' THEN -1
     WHEN f.VALUE:"Side"::STRING = 'LONG' THEN 1
     ELSE NULL
   END AS "tradeMultiplier"
FROM 
   "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" AS t,
   LATERAL FLATTEN(input => t."Sides") f
ORDER BY
   t."StrikePrice" DESC NULLS LAST
LIMIT 6;