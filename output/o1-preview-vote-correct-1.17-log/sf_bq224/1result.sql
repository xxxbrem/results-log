SELECT l."repo_name",
       SUM(CASE WHEN t."type" = 'ForkEvent' THEN 1 ELSE 0 END) AS total_forks,
       SUM(CASE WHEN t."type" = 'IssuesEvent' THEN 1 ELSE 0 END) AS total_issues,
       SUM(CASE WHEN t."type" = 'WatchEvent' THEN 1 ELSE 0 END) AS total_watches,
       SUM(CASE WHEN t."type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent') THEN 1 ELSE 0 END) AS total_combined
FROM "GITHUB_REPOS_DATE"."GITHUB_REPOS"."LICENSES" l
JOIN "GITHUB_REPOS_DATE"."MONTH"."_202204" t
  ON l."repo_name" = t."repo"::VARIANT['name']::STRING
WHERE l."license" IN ('apache-2.0', 'epl-1.0', 'lgpl-2.1', 'mit', 'lgpl-3.0', 'artistic-2.0', 'isc', 'cc0-1.0', 'agpl-3.0', 'bsd-2-clause', 'gpl-2.0', 'gpl-3.0', 'mpl-2.0', 'unlicense', 'bsd-3-clause')
  AND t."type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent')
GROUP BY l."repo_name"
ORDER BY total_combined DESC NULLS LAST
LIMIT 1;