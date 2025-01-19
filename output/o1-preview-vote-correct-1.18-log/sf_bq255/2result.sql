SELECT COUNT(*) AS "Number_of_commit_messages"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_COMMITS c
JOIN GITHUB_REPOS.GITHUB_REPOS.LICENSES l
  ON c."repo_name" = l."repo_name"
JOIN (
  SELECT DISTINCT t."repo_name"
  FROM GITHUB_REPOS.GITHUB_REPOS.LANGUAGES t,
       LATERAL FLATTEN(input => t."language") f
  WHERE f.value:"name"::STRING = 'Shell'
) lang
  ON c."repo_name" = lang."repo_name"
WHERE l."license" = 'apache-2.0'
  AND LENGTH(c."message") BETWEEN 6 AND 9999
  AND LOWER(c."message") NOT LIKE 'merge%'
  AND LOWER(c."message") NOT LIKE 'update%'
  AND LOWER(c."message") NOT LIKE 'test%';