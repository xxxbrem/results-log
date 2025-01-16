SELECT COUNT(*) AS total_commit_messages
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_COMMITS c
JOIN GITHUB_REPOS.GITHUB_REPOS.LICENSES l ON c."repo_name" = l."repo_name"
JOIN GITHUB_REPOS.GITHUB_REPOS.LANGUAGES la ON c."repo_name" = la."repo_name",
LATERAL FLATTEN(input => la."language") f
WHERE LOWER(l."license") = 'apache-2.0'
  AND f.value:"name"::STRING = 'Shell'
  AND LENGTH(c."message") > 5
  AND LENGTH(c."message") < 10000
  AND LOWER(c."message") NOT LIKE 'merge%'
  AND LOWER(c."message") NOT LIKE 'update%'
  AND LOWER(c."message") NOT LIKE 'test%';