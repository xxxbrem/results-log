WITH primary_languages AS (
    SELECT 
        t."repo_name",
        lang.value:"bytes"::NUMBER AS bytes,
        lang.value:"name"::STRING AS language_name,
        ROW_NUMBER() OVER (PARTITION BY t."repo_name" ORDER BY lang.value:"bytes"::NUMBER DESC) AS rn
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES" t,
         LATERAL FLATTEN(input => t."language") lang
)
SELECT sc."repo_name", COUNT(sc."commit") AS commit_count
FROM primary_languages pl
JOIN "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS" sc
    ON pl."repo_name" = sc."repo_name"
WHERE pl.rn = 1
  AND pl.language_name = 'JavaScript'
GROUP BY sc."repo_name"
ORDER BY commit_count DESC NULLS LAST
LIMIT 2;