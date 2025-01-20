WITH trade_data AS (
  SELECT
    (StrikePrice - LastPx) AS intrinsic_value,
    CASE
      WHEN TargetCompID LIKE '%LUCKY%' THEN 'feeling-lucky'
      WHEN TargetCompID LIKE '%MOMO%' THEN 'momentum'
      ELSE 'other'
    END AS strategy
  FROM
    `bigquery-public-data.cymbal_investments.trade_capture_report` AS t,
    UNNEST(t.Sides) AS side
  WHERE
    side.Side = 'LONG'
    AND (TargetCompID LIKE '%LUCKY%' OR TargetCompID LIKE '%MOMO%')
)
SELECT
  ROUND(
    AVG(CASE WHEN strategy = 'feeling-lucky' THEN intrinsic_value END) -
    AVG(CASE WHEN strategy = 'momentum' THEN intrinsic_value END),
    4
  ) AS higher
FROM
  trade_data;