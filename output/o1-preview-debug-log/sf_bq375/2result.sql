SELECT
    LOWER(REGEXP_SUBSTR("path", '\\.([^.\\/]+)$', 1, 1, 'e', 1)) AS "file_type",
    COUNT(*) AS "file_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_FILES
WHERE (LENGTH("path") - LENGTH(REPLACE("path", '/', ''))) > 10
  AND "symlink_target" IS NULL
  AND LOWER(REGEXP_SUBSTR("path", '\\.([^.\\/]+)$', 1, 1, 'e', 1)) IN ('py', 'c', 'ipynb', 'java', 'js')
GROUP BY "file_type"
ORDER BY "file_count" DESC NULLS LAST;