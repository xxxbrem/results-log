SELECT
    ABS(
        AVG(CASE WHEN p.value:"PartyID"::STRING LIKE 'LUCKY%' THEN t."StrikePrice" END) -
        AVG(CASE WHEN p.value:"PartyID"::STRING LIKE 'MOMO%' THEN t."StrikePrice" END)
    ) AS "difference"
FROM
    "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
    LATERAL FLATTEN(input => t."Sides") s,
    LATERAL FLATTEN(input => s.value:"PartyIDs") p
WHERE
    s.value:"Side"::STRING = 'LONG'
    AND t."StrikePrice" IS NOT NULL
    AND (p.value:"PartyID"::STRING LIKE 'LUCKY%' OR p.value:"PartyID"::STRING LIKE 'MOMO%');