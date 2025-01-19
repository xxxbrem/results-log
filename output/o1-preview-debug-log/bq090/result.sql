WITH avg_intrinsic_values AS (
  SELECT 
    CASE 
      WHEN LOWER(party.PartyID) LIKE '%lucky%' THEN 'lucky'
      WHEN LOWER(party.PartyID) LIKE '%momo%' THEN 'momo'
    END AS strategy,
    AVG(t.StrikePrice - t.LastPx) AS avg_intrinsic_value
  FROM `bigquery-public-data.cymbal_investments.trade_capture_report` t
  CROSS JOIN UNNEST(t.Sides) AS side
  CROSS JOIN UNNEST(side.PartyIDs) AS party
  WHERE LOWER(side.Side) = 'long'
    AND (LOWER(party.PartyID) LIKE '%lucky%' OR LOWER(party.PartyID) LIKE '%momo%')
  GROUP BY strategy
)
SELECT ROUND(lucky.avg_intrinsic_value - momo.avg_intrinsic_value, 4) AS higher
FROM (SELECT avg_intrinsic_value FROM avg_intrinsic_values WHERE strategy = 'lucky') AS lucky,
     (SELECT avg_intrinsic_value FROM avg_intrinsic_values WHERE strategy = 'momo') AS momo;