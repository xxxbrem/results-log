SELECT w1.name AS "Winner", w2.name AS "Loser"
FROM "Matches" AS m
JOIN "Wrestlers" AS w1 ON m.winner_id = w1.id
JOIN "Wrestlers" AS w2 ON m.loser_id = w2.id
WHERE m.title_id IN (SELECT id FROM "Belts" WHERE name LIKE '%NXT%')
  AND m.title_change != 1
  AND m.duration IS NOT NULL AND m.duration != ''
ORDER BY (CAST(substr(m.duration, 1, instr(m.duration, ':') -1) AS INTEGER) * 60 +
          CAST(substr(m.duration, instr(m.duration, ':') + 1) AS INTEGER)) ASC
LIMIT 1;