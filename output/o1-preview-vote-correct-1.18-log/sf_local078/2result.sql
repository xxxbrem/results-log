WITH MaxCompositions AS (
    SELECT 
        M."interest_id", 
        M."composition", 
        M."month_year", 
        MAP."interest_name",
        ROW_NUMBER() OVER (
            PARTITION BY M."interest_id" 
            ORDER BY M."composition" DESC, M."month_year" ASC
        ) AS "rn"
    FROM "BANK_SALES_TRADING"."BANK_SALES_TRADING"."INTEREST_METRICS" M
    JOIN "BANK_SALES_TRADING"."BANK_SALES_TRADING"."INTEREST_MAP" MAP
        ON M."interest_id" = MAP."id"
    WHERE M."composition" IS NOT NULL
),
MaxPerInterest AS (
    SELECT 
        "interest_id", 
        "composition", 
        "month_year", 
        "interest_name"
    FROM MaxCompositions
    WHERE "rn" = 1
),
Top10 AS (
    SELECT 
        "month_year", 
        "interest_name", 
        ROUND("composition", 4) AS "composition",
        1 AS "sort_order"
    FROM MaxPerInterest
    ORDER BY "composition" DESC NULLS LAST
    LIMIT 10
),
Bottom10 AS (
    SELECT 
        "month_year", 
        "interest_name", 
        ROUND("composition", 4) AS "composition",
        2 AS "sort_order"
    FROM MaxPerInterest
    ORDER BY "composition" ASC NULLS LAST
    LIMIT 10
),
FinalResult AS (
    SELECT * FROM Top10
    UNION ALL
    SELECT * FROM Bottom10
)
SELECT 
    "Time(MM-YYYY)", 
    "Interest_Name", 
    "Composition_Value"
FROM (
    SELECT 
        FR."month_year" AS "Time(MM-YYYY)", 
        FR."interest_name" AS "Interest_Name", 
        FR."composition" AS "Composition_Value",
        FR."sort_order"
    FROM FinalResult FR
)
ORDER BY 
    "sort_order",
    CASE WHEN "sort_order" = 1 THEN "Composition_Value" END DESC NULLS LAST,
    CASE WHEN "sort_order" = 2 THEN "Composition_Value" END ASC NULLS LAST;