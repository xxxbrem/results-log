SELECT COUNT(*) AS "Number_of_commit_messages"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_COMMITS sc
JOIN GITHUB_REPOS.GITHUB_REPOS.LICENSES l ON sc."repo_name" = l."repo_name"
JOIN (
  SELECT DISTINCT t."repo_name"
  FROM GITHUB_REPOS.GITHUB_REPOS.LANGUAGES t,
  LATERAL FLATTEN(input => t."language") f
  WHERE f.value:"name"::string = 'Shell'
) lang ON sc."repo_name" = lang."repo_name"
WHERE l."license" = 'apache-2.0'
  AND LENGTH(sc."message") > 5
  AND LENGTH(sc."message") < 10000
  AND sc."message" NOT ILIKE 'merge%'
  AND sc."message" NOT ILIKE 'update%'
  AND sc."message" NOT ILIKE 'test%';