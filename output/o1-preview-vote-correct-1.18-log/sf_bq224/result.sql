SELECT l."repo_name", COUNT(*) AS "total_activity"
FROM GITHUB_REPOS_DATE.GITHUB_REPOS."LICENSES" l
JOIN GITHUB_REPOS_DATE.MONTH."_202204" m
  ON l."repo_name" = m."repo"::VARIANT:"name"::STRING
WHERE m."type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent')
  AND l."license" IN ('apache-2.0', 'epl-1.0', 'lgpl-2.1', 'mit', 'lgpl-3.0', 'artistic-2.0', 'isc', 'cc0-1.0', 'agpl-3.0', 'bsd-2-clause', 'gpl-2.0', 'gpl-3.0', 'mpl-2.0', 'unlicense', 'bsd-3-clause')
GROUP BY l."repo_name"
ORDER BY "total_activity" DESC NULLS LAST
LIMIT 1;