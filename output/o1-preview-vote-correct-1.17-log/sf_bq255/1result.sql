SELECT COUNT(*) AS "commit_message_count"
FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS" sc
JOIN (
  SELECT DISTINCT "repo_name"
  FROM "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES",
       LATERAL FLATTEN(input => "language") f
  WHERE f.value:name::STRING = 'Shell'
) lang ON sc."repo_name" = lang."repo_name"
JOIN "GITHUB_REPOS"."GITHUB_REPOS"."LICENSES" l ON sc."repo_name" = l."repo_name"
WHERE l."license" = 'apache-2.0'
  AND LENGTH(sc."message") > 5 AND LENGTH(sc."message") < 10000
  AND LOWER(sc."message") NOT LIKE 'merge%'
  AND LOWER(sc."message") NOT LIKE 'update%'
  AND LOWER(sc."message") NOT LIKE 'test%';