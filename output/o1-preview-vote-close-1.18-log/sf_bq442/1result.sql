SELECT
    t."TradeReportID" AS "tradeID",
    TO_TIMESTAMP(t."MaturityDate" / 1000000) AS "tradeTimestamp",
    CASE SUBSTRING(t."TargetCompID", 1, 4)
        WHEN 'MOMO' THEN 'Momentum'
        WHEN 'LUCK' THEN 'Feeling Lucky'
        WHEN 'PRED' THEN 'Prediction'
        ELSE 'Unknown'
    END AS "algorithm",
    t."Symbol" AS "symbol",
    ROUND(t."LastPx", 4) AS "openPrice",
    ROUND(t."StrikePrice", 4) AS "closePrice",
    f.value:"Side"::STRING AS "tradeDirection",
    CASE
        WHEN f.value:"Side"::STRING = 'SHORT' THEN -1
        WHEN f.value:"Side"::STRING = 'LONG' THEN 1
        ELSE 0
    END AS "tradeMultiplier"
FROM
    CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS."TRADE_CAPTURE_REPORT" t,
    LATERAL FLATTEN(input => t."Sides") f
ORDER BY
    t."StrikePrice" DESC NULLS LAST
LIMIT 6;