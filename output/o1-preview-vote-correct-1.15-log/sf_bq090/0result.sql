SELECT
  ABS(
    AVG(CASE WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING = 'LUCKYES' THEN ("LastPx" - "StrikePrice") END)
    -
    AVG(CASE WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING = 'MOMOES' THEN ("LastPx" - "StrikePrice") END)
  ) AS "difference"
FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
     LATERAL FLATTEN(input => t."Sides") f
WHERE
  f.value:"Side"::STRING = 'LONG'
  AND f.value:"PartyIDs"[0]:"PartyID"::STRING IN ('LUCKYES', 'MOMOES')
  AND "LastPx" IS NOT NULL
  AND "StrikePrice" IS NOT NULL;