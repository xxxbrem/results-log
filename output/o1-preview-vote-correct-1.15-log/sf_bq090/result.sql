SELECT
    ROUND(
        AVG(CASE WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING = 'PREDICTNQ' THEN t."LastPx" - t."StrikePrice" END) -
        AVG(CASE WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING = 'MOMOES' THEN t."LastPx" - t."StrikePrice" END),
        4
    ) AS "difference"
FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
     LATERAL FLATTEN(input => t."Sides") f
WHERE
    f.value:"Side"::STRING = 'LONG' AND
    t."LastPx" IS NOT NULL AND
    t."StrikePrice" IS NOT NULL AND
    f.value:"PartyIDs"[0]:"PartyID"::STRING IN ('PREDICTNQ', 'MOMOES');