WITH TradeData AS (
    SELECT
        CASE
            WHEN p.value:"PartyID"::STRING LIKE 'LUCKY%' THEN 'FEELING_LUCKY'
            WHEN p.value:"PartyID"::STRING LIKE 'MOMO%' THEN 'MOMENTUM'
        END AS "StrategyType",
        t."LastPx",
        t."StrikePrice",
        (t."LastPx" - t."StrikePrice") AS "IntrinsicValue"
    FROM
        "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
        LATERAL FLATTEN(input => t."Sides") s,
        LATERAL FLATTEN(input => s.value:"PartyIDs") p
    WHERE
        t."LastPx" IS NOT NULL
        AND t."StrikePrice" IS NOT NULL
        AND s.value:"Side"::STRING = 'LONG'
        AND (
            p.value:"PartyID"::STRING LIKE 'LUCKY%'
            OR p.value:"PartyID"::STRING LIKE 'MOMO%'
        )
)

SELECT
    ROUND(
        AVG(CASE WHEN "StrategyType" = 'FEELING_LUCKY' THEN "IntrinsicValue" END) -
        AVG(CASE WHEN "StrategyType" = 'MOMENTUM' THEN "IntrinsicValue" END),
        4
    ) AS "DifferenceInAvgIntrinsicValue"
FROM TradeData;