WITH MaxCompositionPerInterest AS
(
    SELECT
        m."interest_id",
        MAX(m."composition") AS "MaxComposition"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_METRICS m
    GROUP BY
        m."interest_id"
),
MaxCompositions AS
(
    SELECT
        m."interest_id",
        m."month_year",
        m."composition"
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_METRICS m
    JOIN
        MaxCompositionPerInterest mc
    ON
        m."interest_id" = mc."interest_id"
        AND m."composition" = mc."MaxComposition"
),
Top10 AS
(
    SELECT
        mc.*,
        ROW_NUMBER() OVER (ORDER BY mc."composition" DESC NULLS LAST) AS "rank",
        'Top' AS "group_type"
    FROM
        MaxCompositions mc
),
Bottom10 AS
(
    SELECT
        mc.*,
        ROW_NUMBER() OVER (ORDER BY mc."composition" ASC NULLS LAST) AS "rank",
        'Bottom' AS "group_type"
    FROM
        MaxCompositions mc
),
Combined AS
(
    SELECT
        t."interest_id",
        t."month_year",
        t."composition",
        t."rank",
        t."group_type"
    FROM
        Top10 t
    WHERE
        t."rank" <= 10
    UNION ALL
    SELECT
        b."interest_id",
        b."month_year",
        b."composition",
        b."rank",
        b."group_type"
    FROM
        Bottom10 b
    WHERE
        b."rank" <= 10
)
SELECT
    c."month_year" AS "Time",
    im."interest_name" AS "Interest_name",
    ROUND(c."composition", 4) AS "Composition_value"
FROM
    Combined c
JOIN
    BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_MAP im
ON
    c."interest_id" = im."id"
ORDER BY
    CASE WHEN c."group_type" = 'Top' THEN 1 ELSE 2 END,
    c."rank" NULLS LAST;