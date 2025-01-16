SELECT
  ROUND(
    AVG(CASE WHEN p.value:"PartyID"::STRING IN ('LUCKYBTC', 'LUCKYES', 'LUCKYNQ')
             THEN GREATEST(t."LastPx" - t."StrikePrice", 0) END)
    -
    AVG(CASE WHEN p.value:"PartyID"::STRING IN ('MOMOES', 'MOMONQ', 'MOMOBTC')
             THEN GREATEST(t."LastPx" - t."StrikePrice", 0) END),
    4
  ) AS "difference"
FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
     LATERAL FLATTEN(INPUT => t."Sides") s,
     LATERAL FLATTEN(INPUT => s.value:"PartyIDs") p
WHERE t."StrikePrice" IS NOT NULL
  AND t."LastPx" IS NOT NULL
  AND s.value:"Side"::STRING = 'LONG'
  AND p.value:"PartyID"::STRING IN ('LUCKYBTC', 'LUCKYES', 'LUCKYNQ', 'MOMOES', 'MOMONQ', 'MOMOBTC');