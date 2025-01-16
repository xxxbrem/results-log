SELECT e."repo_name", e."event_count" AS "total_forks_issues_watches"
FROM (
    SELECT t."repo":name::STRING AS "repo_name", COUNT(*) AS "event_count"
    FROM GITHUB_REPOS_DATE.MONTH."_202204" t
    WHERE t."type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent')
    GROUP BY t."repo":name::STRING
) e
JOIN GITHUB_REPOS_DATE.GITHUB_REPOS.LICENSES l
  ON e."repo_name" = l."repo_name"
WHERE l."license" IN ('mit', 'apache-2.0', 'isc', 'cc0-1.0', 'bsd-2-clause', 'bsd-3-clause', 'unlicense')
ORDER BY "total_forks_issues_watches" DESC NULLS LAST
LIMIT 1;