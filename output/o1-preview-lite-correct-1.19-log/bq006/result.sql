WITH daily_counts AS (
  SELECT
    `date`,
    COUNT(*) AS daily_count
  FROM
    `bigquery-public-data.austin_incidents.incidents_2016`
  WHERE
    LOWER(`descript`) = 'public intoxication'
    AND EXTRACT(YEAR FROM `date`) = 2016
  GROUP BY
    `date`
),
stats AS (
  SELECT
    ROUND(AVG(daily_count), 4) AS mean_count,
    ROUND(STDDEV(daily_count), 4) AS stddev_count
  FROM
    daily_counts
),
z_scores AS (
  SELECT
    dc.`date`,
    dc.daily_count,
    ROUND((dc.daily_count - s.mean_count) / s.stddev_count, 4) AS z_score
  FROM
    daily_counts dc
  CROSS JOIN stats s
)
SELECT
  `date`
FROM
  z_scores
ORDER BY
  z_score DESC
LIMIT
  1 OFFSET 1;