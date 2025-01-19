SELECT
  events.repo_name,
  events.total_events AS combined_total
FROM (
  SELECT
    "repo"::VARIANT:"name"::STRING AS repo_name,
    COUNT(*) AS total_events
  FROM GITHUB_REPOS_DATE.MONTH."_202204"
  WHERE "type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent')
  GROUP BY repo_name
) AS events
JOIN GITHUB_REPOS_DATE.GITHUB_REPOS.LICENSES lic
  ON events.repo_name = lic."repo_name"
WHERE lic."license" IN (
  'apache-2.0', 'epl-1.0', 'lgpl-2.1', 'mit', 'lgpl-3.0',
  'artistic-2.0', 'isc', 'cc0-1.0', 'agpl-3.0', 'bsd-2-clause',
  'gpl-2.0', 'gpl-3.0', 'mpl-2.0', 'unlicense', 'bsd-3-clause'
)
ORDER BY events.total_events DESC NULLS LAST
LIMIT 1;