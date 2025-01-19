SELECT "file_type", COUNT(*) AS "file_count"
FROM (
  SELECT
    CASE
      WHEN SUBSTRING("path", -3) = '.py' THEN 'Python (.py)'
      WHEN SUBSTRING("path", -2) = '.c' THEN 'C (.c)'
      WHEN SUBSTRING("path", -6) = '.ipynb' THEN 'Jupyter Notebook (.ipynb)'
      WHEN SUBSTRING("path", -5) = '.java' THEN 'Java (.java)'
      WHEN SUBSTRING("path", -3) = '.js' THEN 'JavaScript (.js)'
    END AS "file_type"
  FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_FILES"
  WHERE (LENGTH("path") - LENGTH(REPLACE("path", '/', ''))) > 10
    AND (
      SUBSTRING("path", -3) = '.py'
      OR SUBSTRING("path", -2) = '.c'
      OR SUBSTRING("path", -6) = '.ipynb'
      OR SUBSTRING("path", -5) = '.java'
      OR SUBSTRING("path", -3) = '.js'
    )
)
GROUP BY "file_type"
ORDER BY "file_count" DESC NULLS LAST
LIMIT 1;