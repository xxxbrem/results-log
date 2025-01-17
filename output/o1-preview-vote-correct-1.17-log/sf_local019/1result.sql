SELECT w1."name" AS "winner_name", w2."name" AS "loser_name"
FROM WWE.WWE.MATCHES m
JOIN WWE.WWE.WRESTLERS w1 ON m."winner_id" = w1."id"
JOIN WWE.WWE.WRESTLERS w2 ON m."loser_id" = w2."id"
WHERE m."title_id" = 23153
  AND m."title_change" = 0
  AND m."duration" IS NOT NULL
  AND m."duration" != ''
ORDER BY
  CASE
    WHEN REGEXP_LIKE(m."duration", '^\d{1,2}:\d{2}$') THEN
      TO_NUMBER(SPLIT_PART(m."duration", ':', 1)) * 60 + TO_NUMBER(SPLIT_PART(m."duration", ':', 2))
    WHEN REGEXP_LIKE(m."duration", '^\d{1,2}:\d{2}:\d{2}$') THEN
      TO_NUMBER(SPLIT_PART(m."duration", ':', 1)) * 3600 + TO_NUMBER(SPLIT_PART(m."duration", ':', 2)) * 60 + TO_NUMBER(SPLIT_PART(m."duration", ':', 3))
    ELSE NULL
  END ASC
LIMIT 1;