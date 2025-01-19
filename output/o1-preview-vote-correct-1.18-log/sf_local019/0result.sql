WITH nxt_titles AS (
    SELECT "id"
    FROM WWE.WWE.BELTS
    WHERE "name" ILIKE '%NXT%'
),
valid_matches AS (
    SELECT "winner_id", "loser_id",
        (CAST(SPLIT_PART("duration", ':', 1) AS INTEGER) * 60 +
         CAST(SPLIT_PART("duration", ':', 2) AS INTEGER)) AS duration_in_seconds
    FROM WWE.WWE.MATCHES
    WHERE "title_id" IN (SELECT "id" FROM nxt_titles)
      AND "title_change" = 0
      AND "duration" IS NOT NULL
      AND "duration" != ''
),
shortest_match AS (
    SELECT "winner_id", "loser_id"
    FROM valid_matches
    ORDER BY duration_in_seconds ASC
    LIMIT 1
)
SELECT
    W1."name" AS "Winner",
    W2."name" AS "Loser"
FROM shortest_match SM
JOIN WWE.WWE.WRESTLERS W1 ON SM."winner_id" = W1."id"
JOIN WWE.WWE.WRESTLERS W2 ON SM."loser_id" = W2."id";