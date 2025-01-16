SELECT 
    ROUND(
        AVG(CASE WHEN p.value:"PartyID"::STRING IN ('LUCKYBTC', 'LUCKYNQ', 'LUCKYES') THEN t."Quantity" * t."LastPx" END) - 
        AVG(CASE WHEN p.value:"PartyID"::STRING IN ('MOMOBTC', 'MOMONQ', 'MOMOES') THEN t."Quantity" * t."LastPx" END), 4
    ) AS "difference"
FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
     LATERAL FLATTEN(input => t."Sides") f,
     LATERAL FLATTEN(input => f.value:"PartyIDs") p
WHERE f.value:"Side"::STRING = 'LONG';