SELECT
  ROUND(
    (
      SELECT AVG(t."LastPx" - t."StrikePrice")
      FROM CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS.TRADE_CAPTURE_REPORT t,
           LATERAL FLATTEN(input => t."Sides") f,
           LATERAL FLATTEN(input => f.value:"PartyIDs") pid
      WHERE f.value:"Side"::STRING = 'LONG'
        AND pid.value:"PartyRole"::STRING = 'INITIATING TRADER'
        AND pid.value:"PartyIDSource"::STRING = 'PROP CODE'
        AND pid.value:"PartyID"::STRING LIKE 'LUCKY%'
    ) -
    (
      SELECT AVG(t."LastPx" - t."StrikePrice")
      FROM CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS.TRADE_CAPTURE_REPORT t,
           LATERAL FLATTEN(input => t."Sides") f,
           LATERAL FLATTEN(input => f.value:"PartyIDs") pid
      WHERE f.value:"Side"::STRING = 'LONG'
        AND pid.value:"PartyRole"::STRING = 'INITIATING TRADER'
        AND pid.value:"PartyIDSource"::STRING = 'PROP CODE'
        AND pid.value:"PartyID"::STRING LIKE 'MOMO%'
    )
  , 4) AS "higher";