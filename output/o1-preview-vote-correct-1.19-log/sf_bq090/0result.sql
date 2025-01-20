SELECT
    (AVG(CASE WHEN pid.value:"PartyID"::STRING LIKE 'LUCKY%' THEN ("LastPx" - "StrikePrice") END) -
     AVG(CASE WHEN pid.value:"PartyID"::STRING LIKE 'MOMO%' THEN ("LastPx" - "StrikePrice") END)) AS "higher"
FROM CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS.TRADE_CAPTURE_REPORT t,
     LATERAL FLATTEN(input => t."Sides") s,
     LATERAL FLATTEN(input => s.value:"PartyIDs") pid
WHERE s.value:"Side"::STRING = 'LONG'
  AND (pid.value:"PartyID"::STRING LIKE 'LUCKY%' OR pid.value:"PartyID"::STRING LIKE 'MOMO%')
  AND "LastPx" IS NOT NULL AND "StrikePrice" IS NOT NULL;