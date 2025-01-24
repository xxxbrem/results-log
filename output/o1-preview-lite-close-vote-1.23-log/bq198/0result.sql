SELECT market AS Team_Market, name AS Team_Name
FROM (
  SELECT market, name, COUNT(*) AS times_with_max_wins
  FROM (
    SELECT t1.season, t1.market, t1.name
    FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS t1
    WHERE t1.season BETWEEN 1900 AND 2000
      AND t1.wins = (
        SELECT MAX(wins)
        FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` AS t2
        WHERE t2.season = t1.season
      )
  )
  WHERE market IS NOT NULL AND name IS NOT NULL
  GROUP BY market, name
  ORDER BY times_with_max_wins DESC, market, name
  LIMIT 5
)
ORDER BY Team_Market;