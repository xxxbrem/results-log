WITH max_compositions AS (
    SELECT
        im."interest_id",
        imap."interest_name" AS "Interest_Name",
        im."month_year" AS "Time(MM-YYYY)",
        ROUND(im."composition", 4) AS "Composition_Value",
        ROW_NUMBER() OVER (
            PARTITION BY im."interest_id"
            ORDER BY im."composition" DESC NULLS LAST, im."month_year" DESC
        ) AS rn
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_METRICS im
    JOIN
        BANK_SALES_TRADING.BANK_SALES_TRADING.INTEREST_MAP imap
            ON im."interest_id" = imap."id"
    WHERE
        im."composition" IS NOT NULL
)
SELECT
    "Time(MM-YYYY)",
    "Interest_Name",
    "Composition_Value"
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY "Composition_Value" DESC NULLS LAST, "interest_id"
        ) AS desc_rank,
        ROW_NUMBER() OVER (
            ORDER BY "Composition_Value" ASC NULLS LAST, "interest_id"
        ) AS asc_rank
    FROM
        max_compositions
    WHERE
        rn = 1
) ranked
WHERE
    desc_rank <= 10 OR asc_rank <= 10
ORDER BY
    "Composition_Value" DESC NULLS LAST, "interest_id";