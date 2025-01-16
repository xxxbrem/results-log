SELECT
    LOWER(REGEXP_SUBSTR("path", '\\.[^\\.]+$')) AS "file_type",
    COUNT(*) AS "file_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_FILES
WHERE LOWER(REGEXP_SUBSTR("path", '\\.[^\\.]+$')) IN ('.py', '.c', '.ipynb', '.java', '.js')
  AND (LENGTH("path") - LENGTH(REPLACE("path", '/', ''))) > 10
GROUP BY "file_type"
ORDER BY "file_count" DESC NULLS LAST;