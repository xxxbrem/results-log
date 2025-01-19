SELECT COUNT(*) AS "Number_of_commit_messages"
FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS" sc
INNER JOIN "GITHUB_REPOS"."GITHUB_REPOS"."LICENSES" li
    ON sc."repo_name" = li."repo_name"
INNER JOIN "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES" la
    ON sc."repo_name" = la."repo_name",
LATERAL FLATTEN(input => la."language") f
WHERE LENGTH(sc."message") > 5
  AND LENGTH(sc."message") < 10000
  AND LOWER(sc."message") NOT LIKE 'merge%'
  AND LOWER(sc."message") NOT LIKE 'update%'
  AND LOWER(sc."message") NOT LIKE 'test%'
  AND LOWER(f.value:"name"::STRING) = 'shell'
  AND li."license" = 'apache-2.0';