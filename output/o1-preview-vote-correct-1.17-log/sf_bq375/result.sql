SELECT
    CASE
        WHEN "path" LIKE '%.py' THEN 'Python'
        WHEN "path" LIKE '%.c' THEN 'C'
        WHEN "path" LIKE '%.ipynb' THEN 'Jupyter Notebook'
        WHEN "path" LIKE '%.java' THEN 'Java'
        WHEN "path" LIKE '%.js' THEN 'JavaScript'
    END AS "File_type_with_most_files",
    COUNT(*) AS "File_count"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_FILES
WHERE
    ("path" LIKE '%.py'
     OR "path" LIKE '%.c'
     OR "path" LIKE '%.ipynb'
     OR "path" LIKE '%.java'
     OR "path" LIKE '%.js')
    AND regexp_count("path", '/') > 10
GROUP BY "File_type_with_most_files"
ORDER BY "File_count" DESC NULLS LAST
LIMIT 1;