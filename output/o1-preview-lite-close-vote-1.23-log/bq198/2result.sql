SELECT
  hs.market AS Team_Market,
  hs.name AS Team_Name,
  COUNT(*) AS Times_Max_Wins
FROM
  `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons` hs
JOIN (
  SELECT
    season,
    MAX(wins) AS max_wins
  FROM
    `bigquery-public-data.ncaa_basketball.mbb_historical_teams_seasons`
  WHERE
    season BETWEEN 1900 AND 2000
  GROUP BY
    season
) mw
ON
  hs.season = mw.season
  AND hs.wins = mw.max_wins
WHERE
  hs.season BETWEEN 1900 AND 2000
GROUP BY
  hs.market,
  hs.name
ORDER BY
  Times_Max_Wins DESC
LIMIT
  5;