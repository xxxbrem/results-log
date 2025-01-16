SELECT
    ROUND(
        AVG(CASE WHEN "Strategy" = 'momentum' THEN "IntrinsicValue" END) -
        AVG(CASE WHEN "Strategy" = 'feeling-lucky' THEN "IntrinsicValue" END),
        4
    ) AS "difference"
FROM (
    SELECT
        CASE
            WHEN f2.value:"PartyID"::STRING ILIKE '%LUCKY%' THEN 'feeling-lucky'
            WHEN f2.value:"PartyID"::STRING ILIKE '%MOMO%' THEN 'momentum'
        END AS "Strategy",
        t."LastPx" - t."StrikePrice" AS "IntrinsicValue"
    FROM
        "CYMBAL_INVESTMENTS"."CYMBAL_INVESTMENTS"."TRADE_CAPTURE_REPORT" t,
        LATERAL FLATTEN(input => t."Sides") f,
        LATERAL FLATTEN(input => f.value:"PartyIDs") f2
    WHERE
        f.value:"Side"::STRING = 'LONG'
        AND t."LastPx" IS NOT NULL
        AND t."StrikePrice" IS NOT NULL
        AND (f2.value:"PartyID"::STRING ILIKE '%LUCKY%' OR f2.value:"PartyID"::STRING ILIKE '%MOMO%')
) AS sub;