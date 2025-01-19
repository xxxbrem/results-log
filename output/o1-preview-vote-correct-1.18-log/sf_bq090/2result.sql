WITH strat_averages AS (
    SELECT
        CASE
            WHEN LEFT(p.value::VARIANT:"PartyID"::STRING, 5) = 'LUCKY' THEN 'feeling-lucky'
            WHEN LEFT(p.value::VARIANT:"PartyID"::STRING, 4) = 'MOMO' THEN 'momentum'
        END AS strat,
        AVG(t."LastPx" - t."StrikePrice") AS avg_intrinsic_value
    FROM CYMBAL_INVESTMENTS.CYMBAL_INVESTMENTS."TRADE_CAPTURE_REPORT" t,
         LATERAL FLATTEN(input => t."Sides") f,
         LATERAL FLATTEN(input => f.value::VARIANT:"PartyIDs") p
    WHERE
        f.value::VARIANT:"Side"::STRING = 'LONG'
        AND t."LastPx" IS NOT NULL
        AND t."StrikePrice" IS NOT NULL
        AND (
            LEFT(p.value::VARIANT:"PartyID"::STRING, 5) = 'LUCKY' OR
            LEFT(p.value::VARIANT:"PartyID"::STRING, 4) = 'MOMO'
        )
    GROUP BY strat
)
SELECT
    'higher',
    ROUND(
        (SELECT avg_intrinsic_value FROM strat_averages WHERE strat = 'feeling-lucky') -
        (SELECT avg_intrinsic_value FROM strat_averages WHERE strat = 'momentum'),
        4
    ) AS value;