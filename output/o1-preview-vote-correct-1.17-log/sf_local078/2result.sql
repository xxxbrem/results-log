WITH MaxCompositions AS (
    SELECT
        I."interest_name",
        MAX(M."composition") AS "max_composition"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_METRICS M
        INNER JOIN BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_MAP I
            ON M."interest_id" = I."id"
    WHERE
        M."composition" IS NOT NULL
    GROUP BY
        I."interest_name"
),
MaxCompositionTime AS (
    SELECT
        M."month_year" AS "time",
        I."interest_name",
        M."composition"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_METRICS M
        INNER JOIN BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_MAP I
            ON M."interest_id" = I."id"
        INNER JOIN MaxCompositions C
            ON I."interest_name" = C."interest_name" AND M."composition" = C."max_composition"
    WHERE
        M."composition" IS NOT NULL
),
RankedCompositions AS (
    SELECT
        "time",
        "interest_name",
        ROUND("composition", 4) AS "composition_value",
        ROW_NUMBER() OVER (ORDER BY "composition_value" DESC NULLS LAST, "interest_name") AS rn_desc,
        ROW_NUMBER() OVER (ORDER BY "composition_value" ASC NULLS LAST, "interest_name") AS rn_asc
    FROM MaxCompositionTime
),
TopBottomCompositions AS (
    SELECT "time", "interest_name", "composition_value", rn_desc AS rn
    FROM RankedCompositions
    WHERE rn_desc <= 10
    UNION ALL
    SELECT "time", "interest_name", "composition_value", rn_asc AS rn
    FROM RankedCompositions
    WHERE rn_asc <= 10
)
SELECT "time", "interest_name", "composition_value"
FROM TopBottomCompositions
ORDER BY rn;