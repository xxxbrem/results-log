WITH nxt_belts AS (
  SELECT "id"
  FROM "WWE"."WWE"."BELTS"
  WHERE "name" LIKE '%NXT%'
),
shortest_match AS (
  SELECT
    m."winner_id",
    m."loser_id",
    m."duration",
    ROUND(CASE
      WHEN m."duration" LIKE '%:%:%' THEN
        SPLIT_PART(m."duration", ':', 1)::FLOAT * 3600 +
        SPLIT_PART(m."duration", ':', 2)::FLOAT * 60 +
        SPLIT_PART(m."duration", ':', 3)::FLOAT
      WHEN m."duration" LIKE '%:%' THEN
        SPLIT_PART(m."duration", ':', 1)::FLOAT * 60 +
        SPLIT_PART(m."duration", ':', 2)::FLOAT
      ELSE
        0
    END, 4) AS total_seconds
  FROM "WWE"."WWE"."MATCHES" m
  WHERE m."title_id" IN (SELECT "id" FROM nxt_belts)
    AND (m."title_change" != 1 OR m."title_change" IS NULL)
    AND m."duration" IS NOT NULL AND m."duration" != ''
  ORDER BY total_seconds ASC
  LIMIT 1
)
SELECT
  w."name" AS "winner_name",
  l."name" AS "loser_name"
FROM shortest_match m
LEFT JOIN "WWE"."WWE"."WRESTLERS" w ON m."winner_id" = w."id"
LEFT JOIN "WWE"."WWE"."WRESTLERS" l ON m."loser_id" = l."id";