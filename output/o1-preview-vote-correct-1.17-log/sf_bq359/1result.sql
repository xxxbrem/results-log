WITH repo_primary_language AS (
  SELECT t."repo_name",
         f.value:"name"::STRING AS "language_name",
         f.value:"bytes"::NUMBER AS "bytes",
         ROW_NUMBER() OVER (PARTITION BY t."repo_name" ORDER BY f.value:"bytes"::NUMBER DESC) AS rn
  FROM GITHUB_REPOS.GITHUB_REPOS.LANGUAGES t,
       LATERAL FLATTEN(input => t."language") f
)
SELECT c."repo_name", COUNT(*) AS "commit_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_COMMITS c
JOIN repo_primary_language l
  ON c."repo_name" = l."repo_name"
WHERE l.rn = 1 AND l."language_name" = 'JavaScript'
GROUP BY c."repo_name"
ORDER BY "commit_count" DESC NULLS LAST
LIMIT 2;