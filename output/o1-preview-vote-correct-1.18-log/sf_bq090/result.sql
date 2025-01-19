WITH TradeData AS (
  SELECT
    t."TradeReportID",
    t."LastPx",
    t."StrikePrice",
    t."Quantity",
    s.value:"Side"::STRING AS "Side",
    p.value:"PartyID"::STRING AS "PartyID",
    CASE 
      WHEN p.value:"PartyID"::STRING LIKE 'MOMO%' THEN 'momentum'
      WHEN p.value:"PartyID"::STRING LIKE 'PREDICT%' THEN 'feeling-lucky'
      ELSE 'other'
    END AS "Strategy"
  FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
       LATERAL FLATTEN(input => t."Sides") s,
       LATERAL FLATTEN(input => s.value:"PartyIDs") p
)
SELECT 
  ROUND(
    COALESCE(
      (
        SELECT AVG( ("LastPx" - "StrikePrice") * "Quantity" )
        FROM TradeData
        WHERE "Side" = 'LONG' AND "Strategy" = 'feeling-lucky'
      ), 0
    ) -
    COALESCE(
      (
        SELECT AVG( ("LastPx" - "StrikePrice") * "Quantity" )
        FROM TradeData
        WHERE "Side" = 'LONG' AND "Strategy" = 'momentum'
      ), 0
    ), 4
  ) AS "higher";