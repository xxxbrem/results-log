WITH InterestMax AS (
    SELECT
        im."interest_id",
        m."interest_name",
        im."month_year",
        im."composition",
        ROW_NUMBER() OVER (
            PARTITION BY im."interest_id"
            ORDER BY im."composition" DESC
        ) AS rn
    FROM
        BANK_SALES_TRADING.BANK_SALES_TRADING."INTEREST_METRICS" im
    JOIN
        BANK_SALES_TRADING.BANK_SALES_TRADING."INTEREST_MAP" m
        ON im."interest_id" = m."id"
    WHERE
        im."interest_id" IS NOT NULL
        AND im."composition" IS NOT NULL
        AND im."month_year" IS NOT NULL
)
SELECT
    "month_year",
    "interest_name",
    ROUND("composition", 4) AS "composition"
FROM (
    SELECT
        "month_year",
        "interest_name",
        "composition",
        ROW_NUMBER() OVER (ORDER BY "composition" DESC NULLS LAST) AS top_rank,
        ROW_NUMBER() OVER (ORDER BY "composition" ASC NULLS LAST) AS bottom_rank
    FROM
        InterestMax
    WHERE
        rn = 1
) sub
WHERE
    top_rank <= 10 OR bottom_rank <= 10
ORDER BY
    "composition" DESC NULLS LAST;