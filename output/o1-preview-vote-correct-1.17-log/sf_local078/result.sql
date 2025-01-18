WITH max_compositions AS (
    SELECT
        "interest_id",
        MAX("composition") AS "max_composition"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."INTEREST_METRICS"
    WHERE
        "composition" IS NOT NULL
    GROUP BY
        "interest_id"
),
interest_max_times AS (
    SELECT
        im."interest_id",
        im."month_year",
        im."composition"
    FROM
        "BANK_SALES_TRADING"."BANK_SALES_TRADING"."INTEREST_METRICS" im
        INNER JOIN max_compositions mc
            ON im."interest_id" = mc."interest_id"
            AND im."composition" = mc."max_composition"
),
interests_with_names AS (
    SELECT
        imt."month_year",
        imap."interest_name",
        imt."composition"
    FROM
        interest_max_times imt
        LEFT JOIN "BANK_SALES_TRADING"."BANK_SALES_TRADING"."INTEREST_MAP" imap
            ON imt."interest_id" = imap."id"
    WHERE
        imap."interest_name" IS NOT NULL
),
top_10 AS (
    SELECT
        *
    FROM
        interests_with_names
    ORDER BY
        "composition" DESC NULLS LAST
    LIMIT 10
),
bottom_10 AS (
    SELECT
        *
    FROM
        interests_with_names
    ORDER BY
        "composition" ASC NULLS LAST
    LIMIT 10
),
combined AS (
    SELECT
        "month_year",
        "interest_name",
        "composition"
    FROM
        top_10
    UNION ALL
    SELECT
        "month_year",
        "interest_name",
        "composition"
    FROM
        bottom_10
)
SELECT
    "month_year" AS "Time(MM-YYYY)",
    "interest_name" AS "Interest_Name",
    ROUND("composition", 4) AS "Composition_Value"
FROM
    combined
ORDER BY
    "Composition_Value" DESC NULLS LAST
;