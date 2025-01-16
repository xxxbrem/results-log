SELECT
    LOWER(REGEXP_SUBSTR("path", '\\.[^\\.]+$')) AS "extension",
    COUNT(*) AS "file_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_FILES
WHERE (LENGTH("path") - LENGTH(REPLACE("path", '/', ''))) > 10
  AND LOWER(REGEXP_SUBSTR("path", '\\.[^\\.]+$')) IN ('.py', '.c', '.ipynb', '.java', '.js')
GROUP BY "extension"
ORDER BY "file_count" DESC NULLS LAST;