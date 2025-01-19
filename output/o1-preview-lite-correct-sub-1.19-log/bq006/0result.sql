WITH daily_counts AS (
  SELECT
    `date`,
    COUNT(*) AS incident_count
  FROM
    `bigquery-public-data.austin_incidents.incidents_2016`
  WHERE
    `descript` = 'PUBLIC INTOXICATION'
  GROUP BY
    `date`
),
stats AS (
  SELECT
    AVG(incident_count) AS mean_incidents,
    STDDEV(incident_count) AS stddev_incidents
  FROM
    daily_counts
),
daily_z_scores AS (
  SELECT
    dc.`date`,
    dc.incident_count,
    ROUND((dc.incident_count - s.mean_incidents) / s.stddev_incidents, 4) AS z_score
  FROM
    daily_counts dc
  CROSS JOIN
    stats s
)
SELECT
  `date`
FROM
  daily_z_scores
ORDER BY
  z_score DESC
LIMIT 1 OFFSET 1;