SELECT
  ROUND(
    AVG(CASE WHEN Strategy = 'feeling-lucky' THEN IntrinsicValue END) -
    AVG(CASE WHEN Strategy = 'momentum' THEN IntrinsicValue END),
    4
  ) AS "difference"
FROM (
  SELECT
    (t."LastPx" - t."StrikePrice") * t."Quantity" AS IntrinsicValue,
    f.value:"Side"::STRING AS "Side",
    CASE
      WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING LIKE 'LUCKY%' THEN 'feeling-lucky'
      WHEN f.value:"PartyIDs"[0]:"PartyID"::STRING LIKE 'MOMO%' THEN 'momentum'
      ELSE NULL
    END AS Strategy
  FROM
    "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
    LATERAL FLATTEN(input => t."Sides") f
  WHERE
    t."LastPx" IS NOT NULL AND
    t."StrikePrice" IS NOT NULL AND
    t."Quantity" IS NOT NULL AND
    f.value:"Side"::STRING = 'LONG' AND
    f.value:"PartyIDs"[0]:"PartyID"::STRING IS NOT NULL
) sub
WHERE
  Strategy IS NOT NULL;