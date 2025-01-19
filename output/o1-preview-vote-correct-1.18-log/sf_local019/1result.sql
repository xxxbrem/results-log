WITH matches_with_duration AS (
  SELECT
    M."id",
    M."winner_id",
    M."loser_id",
    M."duration",
    (TRY_TO_NUMBER(SPLIT_PART(M."duration", ':', 1)) * 60 + TRY_TO_NUMBER(SPLIT_PART(M."duration", ':', 2))) AS total_seconds
  FROM WWE.WWE.MATCHES M
  WHERE
    M."title_id" IN (SELECT "id" FROM WWE.WWE.BELTS WHERE "name" ILIKE '%NXT%')
    AND M."title_change" = 0
    AND M."duration" IS NOT NULL AND M."duration" <> ''
    AND TRY_TO_NUMBER(SPLIT_PART(M."duration", ':', 1)) IS NOT NULL
    AND TRY_TO_NUMBER(SPLIT_PART(M."duration", ':', 2)) IS NOT NULL
)
SELECT
  W1."name" AS wrestler1_name,
  W2."name" AS wrestler2_name
FROM matches_with_duration MWD
JOIN WWE.WWE.WRESTLERS W1 ON MWD."winner_id" = W1."id"
JOIN WWE.WWE.WRESTLERS W2 ON MWD."loser_id" = W2."id"
WHERE
  MWD.total_seconds = (
    SELECT MIN(total_seconds)
    FROM matches_with_duration
  )
LIMIT 1