SELECT s.market, COUNT(*) AS num_max_wins
FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS s
JOIN (
  SELECT season, MAX(wins) AS max_wins
  FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons`
  WHERE season BETWEEN 1900 AND 2000
  GROUP BY season
) AS m
ON s.season = m.season AND s.wins = m.max_wins
WHERE s.season BETWEEN 1900 AND 2000
GROUP BY s.market
ORDER BY num_max_wins DESC, s.market
LIMIT 5;