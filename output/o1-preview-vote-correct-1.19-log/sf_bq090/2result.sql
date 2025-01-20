WITH strategy_intrinsic AS (
    SELECT
        CASE
            WHEN UPPER(p.value:"PartyID"::STRING) = 'PREDICTNQ' THEN 'feeling-lucky'
            WHEN UPPER(p.value:"PartyID"::STRING) = 'MOMOES' THEN 'momentum'
            ELSE 'other'
        END AS "Strategy",
        GREATEST(0, t."LastPx" - t."StrikePrice") AS "IntrinsicValue"
    FROM "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t
    , LATERAL FLATTEN(input => t."Sides") f
    , LATERAL FLATTEN(input => f.value:"PartyIDs") p
    WHERE UPPER(f.value:"Side"::STRING) = 'LONG'
      AND t."StrikePrice" IS NOT NULL
      AND t."LastPx" IS NOT NULL
      AND UPPER(p.value:"PartyID"::STRING) IN ('PREDICTNQ', 'MOMOES')
)
SELECT
    ROUND(
        AVG(CASE WHEN "Strategy" = 'feeling-lucky' THEN "IntrinsicValue" END)
        -
        AVG(CASE WHEN "Strategy" = 'momentum' THEN "IntrinsicValue" END),
        4
    ) AS "higher"
FROM strategy_intrinsic