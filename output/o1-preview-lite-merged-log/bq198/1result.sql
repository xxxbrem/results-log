SELECT s.market AS Team_Market, s.name AS Team_Name, COUNT(*) AS Times_Max_Wins
FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` s
JOIN (
  SELECT season, MAX(wins) AS max_wins
  FROM `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons`
  WHERE season BETWEEN 1900 AND 2000
  GROUP BY season
) m ON s.season = m.season AND s.wins = m.max_wins
WHERE s.season BETWEEN 1900 AND 2000
GROUP BY Team_Market, Team_Name
ORDER BY Times_Max_Wins DESC
LIMIT 5;