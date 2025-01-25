SELECT hts.`market`, COUNT(*) AS `num_max_wins`
FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS hts
JOIN (
  SELECT `season`, MAX(`wins`) AS `max_wins`
  FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons`
  WHERE `season` BETWEEN 1900 AND 2000
  GROUP BY `season`
) AS max_wins_season
ON hts.`season` = max_wins_season.`season` AND hts.`wins` = max_wins_season.`max_wins`
WHERE hts.`season` BETWEEN 1900 AND 2000
  AND hts.`market` IS NOT NULL AND TRIM(hts.`market`) != ''
GROUP BY hts.`market`
ORDER BY `num_max_wins` DESC
LIMIT 5