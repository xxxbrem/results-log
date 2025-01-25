SELECT market, COUNT(*) AS num_max_wins
FROM (
  SELECT t.season, t.market
  FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS t
  WHERE t.season BETWEEN 1900 AND 2000
    AND t.wins = (
      SELECT MAX(wins)
      FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons`
      WHERE season = t.season
    )
)
GROUP BY market
ORDER BY num_max_wins DESC
LIMIT 5;