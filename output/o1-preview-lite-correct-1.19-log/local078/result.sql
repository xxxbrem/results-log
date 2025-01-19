WITH max_comp AS (
    SELECT im."interest_id", im."month_year", im."composition",
        im."_year", im."_month",
        ROW_NUMBER() OVER (
            PARTITION BY im."interest_id"
            ORDER BY im."composition" DESC, im."_year", im."_month"
        ) AS rn
    FROM "interest_metrics" im
),
max_comp_interest AS (
    SELECT mc."interest_id", mc."month_year", mc."composition"
    FROM max_comp mc
    WHERE mc.rn = 1
),
top10 AS (
    SELECT mc."interest_id", mc."month_year", mc."composition"
    FROM max_comp_interest mc
    ORDER BY mc."composition" DESC, mc."interest_id" ASC
    LIMIT 10
),
bottom10 AS (
    SELECT mc."interest_id", mc."month_year", mc."composition"
    FROM max_comp_interest mc
    ORDER BY mc."composition" ASC, mc."interest_id" ASC
    LIMIT 10
)
SELECT t."month_year" AS "Time(MM-YYYY)", imap."interest_name" AS "Interest Name", ROUND(t."composition", 4) AS "Composition"
FROM top10 t
JOIN "interest_map" imap ON t."interest_id" = imap."id"
UNION ALL
SELECT b."month_year" AS "Time(MM-YYYY)", imap."interest_name" AS "Interest Name", ROUND(b."composition", 4) AS "Composition"
FROM bottom10 b
JOIN "interest_map" imap ON b."interest_id" = imap."id"
ORDER BY "Composition" DESC;