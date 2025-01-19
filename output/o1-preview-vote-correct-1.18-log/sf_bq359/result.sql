WITH primary_language AS (
    SELECT t."repo_name",
           f.VALUE:"name"::STRING AS "language_name",
           ROW_NUMBER() OVER (PARTITION BY t."repo_name" ORDER BY f.VALUE:"bytes"::NUMBER DESC) AS rn
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES" t,
         LATERAL FLATTEN(input => t."language") f
)
SELECT pl."repo_name", c."commit_count"
FROM primary_language pl
JOIN (
    SELECT "repo_name", COUNT(*) AS "commit_count"
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS"
    GROUP BY "repo_name"
) c ON pl."repo_name" = c."repo_name"
WHERE pl.rn = 1 AND pl."language_name" = 'JavaScript'
ORDER BY c."commit_count" DESC NULLS LAST
LIMIT 2;