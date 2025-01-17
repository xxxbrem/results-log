WITH NXT_Titles AS (
    SELECT "id"
    FROM WWE.WWE.BELTS
    WHERE "name" LIKE '%NXT%'
),
NXT_Matches AS (
    SELECT
        "winner_id",
        "loser_id",
        CASE
            WHEN (LENGTH("duration") - LENGTH(REPLACE("duration", ':', ''))) = 1 THEN
                (TRY_TO_NUMBER(SPLIT_PART("duration", ':', 1)) * 60) +
                TRY_TO_NUMBER(SPLIT_PART("duration", ':', 2))
            WHEN (LENGTH("duration") - LENGTH(REPLACE("duration", ':', ''))) = 2 THEN
                (TRY_TO_NUMBER(SPLIT_PART("duration", ':', 1)) * 3600) +
                (TRY_TO_NUMBER(SPLIT_PART("duration", ':', 2)) * 60) +
                TRY_TO_NUMBER(SPLIT_PART("duration", ':', 3))
            ELSE NULL
        END AS duration_in_seconds
    FROM WWE.WWE.MATCHES
    WHERE
        "title_id" IN (SELECT "id" FROM NXT_Titles)
        AND "title_change" = 0
        AND "duration" IS NOT NULL
        AND "duration" != ''
),
shortest_match AS (
    SELECT
        "winner_id",
        "loser_id"
    FROM NXT_Matches
    WHERE duration_in_seconds IS NOT NULL
    ORDER BY duration_in_seconds ASC
    LIMIT 1
)
SELECT
    w1."name" AS winner_name,
    w2."name" AS loser_name
FROM shortest_match sm
JOIN WWE.WWE.WRESTLERS w1 ON sm."winner_id" = w1."id"
JOIN WWE.WWE.WRESTLERS w2 ON sm."loser_id" = w2."id";