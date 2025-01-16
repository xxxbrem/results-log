WITH avg_intrinsic_values AS (
    SELECT
        CASE
            WHEN p.value:"PartyID"::STRING = 'PREDICTNQ' THEN 'feeling-lucky'
            WHEN p.value:"PartyID"::STRING = 'PREDICTES' THEN 'momentum'
        END AS "Strategy",
        AVG(t."LastPx" - t."StrikePrice") AS "avg_intrinsic_value"
    FROM
        CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS.TRADE_CAPTURE_REPORT t,
        LATERAL FLATTEN(input => t."Sides") s,
        LATERAL FLATTEN(input => s.value:"PartyIDs") p
    WHERE
        t."StrikePrice" IS NOT NULL
        AND t."LastPx" IS NOT NULL
        AND s.value:"Side"::STRING = 'LONG'
        AND p.value:"PartyID"::STRING IN ('PREDICTNQ', 'PREDICTES')
    GROUP BY
        CASE
            WHEN p.value:"PartyID"::STRING = 'PREDICTNQ' THEN 'feeling-lucky'
            WHEN p.value:"PartyID"::STRING = 'PREDICTES' THEN 'momentum'
        END
)
SELECT
    ROUND(
        ABS(
            (SELECT "avg_intrinsic_value" FROM avg_intrinsic_values WHERE "Strategy" = 'feeling-lucky')
            -
            (SELECT "avg_intrinsic_value" FROM avg_intrinsic_values WHERE "Strategy" = 'momentum')
        ),
        4
    ) AS "difference";