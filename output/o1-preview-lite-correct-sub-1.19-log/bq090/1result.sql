SELECT
  ROUND(lucky.avg_intrinsic_value - momo.avg_intrinsic_value, 4) AS higher
FROM
  (
    SELECT AVG(t.StrikePrice - t.LastPx) AS avg_intrinsic_value
    FROM `bigquery-public-data.cymbal_investments.trade_capture_report` AS t
    CROSS JOIN UNNEST(t.Sides) AS side
    WHERE side.Side = 'LONG' AND t.TargetCompID LIKE '%LUCKY%'
  ) AS lucky,
  (
    SELECT AVG(t.StrikePrice - t.LastPx) AS avg_intrinsic_value
    FROM `bigquery-public-data.cymbal_investments.trade_capture_report` AS t
    CROSS JOIN UNNEST(t.Sides) AS side
    WHERE side.Side = 'LONG' AND t.TargetCompID LIKE '%MOMO%'
  ) AS momo