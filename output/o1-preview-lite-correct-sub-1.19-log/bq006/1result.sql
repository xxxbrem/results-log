WITH daily_counts AS (
  SELECT
    date,
    COUNT(*) AS daily_count
  FROM
    `bigquery-public-data.austin_incidents.incidents_2016`
  WHERE
    descript = 'PUBLIC INTOXICATION'
  GROUP BY
    date
),
stats AS (
  SELECT
    AVG(daily_count) AS mean_daily_count,
    STDDEV(daily_count) AS stddev_daily_count
  FROM
    daily_counts
),
z_scores AS (
  SELECT
    dc.date,
    dc.daily_count,
    ROUND((dc.daily_count - s.mean_daily_count)/s.stddev_daily_count, 4) AS z_score
  FROM
    daily_counts dc,
    stats s
)
SELECT
  date
FROM (
  SELECT
    date,
    z_score,
    ROW_NUMBER() OVER (ORDER BY z_score DESC) AS rn
  FROM
    z_scores
)
WHERE
  rn = 2;