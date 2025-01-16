WITH intrinsic_values AS (
  SELECT
    CASE
      WHEN pi.value:"PartyID"::STRING = 'PREDICTNQ' THEN 'feeling-lucky'
      WHEN pi.value:"PartyID"::STRING = 'MOMOES' THEN 'momentum'
    END AS "Strategy",
    t."LastPx" - t."StrikePrice" AS "IntrinsicValue"
  FROM
    CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS.TRADE_CAPTURE_REPORT t,
    LATERAL FLATTEN(input => t."Sides") f,
    LATERAL FLATTEN(input => f.value:"PartyIDs") pi
  WHERE
    f.value:"Side" = 'LONG'
    AND pi.value:"PartyID"::STRING IN ('PREDICTNQ', 'MOMOES')
    AND t."LastPx" IS NOT NULL
    AND t."StrikePrice" IS NOT NULL
)
SELECT
  ROUND(
    ABS(
      (SELECT AVG("IntrinsicValue") FROM intrinsic_values WHERE "Strategy" = 'feeling-lucky') -
      (SELECT AVG("IntrinsicValue") FROM intrinsic_values WHERE "Strategy" = 'momentum')
    ),
    4
  ) AS "difference";