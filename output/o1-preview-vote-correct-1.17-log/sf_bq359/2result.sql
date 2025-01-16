WITH language_bytes AS (
    SELECT
        t."repo_name",
        f.value:"name"::STRING AS "language",
        f.value:"bytes"::NUMBER AS "bytes"
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES" t,
         LATERAL FLATTEN(input => t."language") f
),
primary_languages AS (
    SELECT
        lb."repo_name",
        lb."language",
        lb."bytes",
        ROW_NUMBER() OVER (PARTITION BY lb."repo_name" ORDER BY lb."bytes" DESC) AS "rn"
    FROM language_bytes lb
),
javascript_repos AS (
    SELECT "repo_name"
    FROM primary_languages
    WHERE "rn" = 1 AND "language" = 'JavaScript'
),
commit_counts AS (
    SELECT "repo_name", COUNT(DISTINCT "commit") AS "commit_count"
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS"
    GROUP BY "repo_name"
)
SELECT c."repo_name", c."commit_count"
FROM commit_counts c
JOIN javascript_repos j
    ON c."repo_name" = j."repo_name"
ORDER BY c."commit_count" DESC NULLS LAST
LIMIT 2;