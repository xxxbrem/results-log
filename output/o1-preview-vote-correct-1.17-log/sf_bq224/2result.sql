WITH april_events AS (
  SELECT
    LOWER("repo"::VARIANT:"name"::STRING) AS "repo_name",
    "type"
  FROM GITHUB_REPOS_DATE.YEAR."_2022"
  WHERE
    TO_TIMESTAMP_NTZ("created_at" / 1e6) BETWEEN '2022-04-01' AND '2022-04-30 23:59:59'
    AND "type" IN ('ForkEvent', 'IssuesEvent', 'WatchEvent')
),
event_counts AS (
  SELECT
    "repo_name",
    SUM(CASE WHEN "type" = 'ForkEvent' THEN 1 ELSE 0 END) AS "forks",
    SUM(CASE WHEN "type" = 'IssuesEvent' THEN 1 ELSE 0 END) AS "issues",
    SUM(CASE WHEN "type" = 'WatchEvent' THEN 1 ELSE 0 END) AS "watches"
  FROM april_events
  GROUP BY "repo_name"
)
SELECT
  e."repo_name",
  e."forks",
  e."issues",
  e."watches",
  (e."forks" + e."issues" + e."watches") AS "total_combined"
FROM event_counts e
JOIN (
  SELECT DISTINCT LOWER("repo_name") AS "repo_name"
  FROM GITHUB_REPOS_DATE.GITHUB_REPOS.LICENSES
  WHERE "license" IN ('apache-2.0', 'epl-1.0', 'lgpl-2.1', 'mit', 'lgpl-3.0', 'artistic-2.0', 'isc', 'cc0-1.0', 'agpl-3.0', 'bsd-2-clause', 'gpl-2.0', 'gpl-3.0', 'mpl-2.0', 'unlicense', 'bsd-3-clause')
) l ON e."repo_name" = l."repo_name"
ORDER BY "total_combined" DESC NULLS LAST
LIMIT 1;