SELECT
  ROUND(
    AVG(CASE WHEN p.PartyID LIKE 'LUCKY%' THEN t.StrikePrice END) -
    AVG(CASE WHEN p.PartyID LIKE 'MOMO%' THEN t.StrikePrice END),
    4
  ) AS higher
FROM `bigquery-public-data.cymbal_investments.trade_capture_report` AS t
JOIN UNNEST(t.Sides) AS s
JOIN UNNEST(s.PartyIDs) AS p
WHERE LOWER(s.Side) = 'long' AND (p.PartyID LIKE 'LUCKY%' OR p.PartyID LIKE 'MOMO%')
;