WITH primary_languages AS (
  SELECT
    "repo_name",
    f.value:"name"::STRING AS "language_name",
    f.value:"bytes"::NUMBER AS "bytes",
    ROW_NUMBER() OVER (PARTITION BY "repo_name" ORDER BY f.value:"bytes"::NUMBER DESC) AS rn
  FROM "GITHUB_REPOS"."GITHUB_REPOS"."LANGUAGES",
  LATERAL FLATTEN(input => "language") f
),
js_repos AS (
  SELECT "repo_name"
  FROM primary_languages
  WHERE rn = 1 AND "language_name" = 'JavaScript'
),
commit_counts AS (
  SELECT "repo_name", COUNT(*) AS "commit_count"
  FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS"
  GROUP BY "repo_name"
)
SELECT c."repo_name", c."commit_count"
FROM commit_counts c
JOIN js_repos j ON c."repo_name" = j."repo_name"
ORDER BY c."commit_count" DESC NULLS LAST
LIMIT 2;