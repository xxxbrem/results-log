SELECT
    c."repo_name",
    COUNT(*) AS "commit_count"
FROM
    "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_COMMITS" c
JOIN (
    SELECT DISTINCT "repo_name"
    FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_FILES"
    WHERE LOWER("path") LIKE '%.js%'
) js_repos ON c."repo_name" = js_repos."repo_name"
GROUP BY
    c."repo_name"
ORDER BY
    "commit_count" DESC NULLS LAST
LIMIT 2;