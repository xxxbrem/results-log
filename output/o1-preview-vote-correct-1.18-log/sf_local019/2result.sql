SELECT w1."name" AS "Winner", w2."name" AS "Loser"
FROM WWE.WWE."MATCHES" m
JOIN WWE.WWE."BELTS" b ON m."title_id" = b."id"
JOIN WWE.WWE."WRESTLERS" w1 ON m."winner_id" = w1."id"
JOIN WWE.WWE."WRESTLERS" w2 ON m."loser_id" = w2."id"
WHERE b."name" ILIKE '%NXT%'
  AND m."title_change" = 0
  AND m."duration" IS NOT NULL
  AND m."duration" != ''
  AND m."duration" LIKE '__:__'
ORDER BY 
  (CAST(SPLIT_PART(m."duration", ':', 1) AS INTEGER) * 60 + CAST(SPLIT_PART(m."duration", ':', 2) AS INTEGER)) ASC,
  m."id" ASC
LIMIT 1;