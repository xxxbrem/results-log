SELECT "extension" AS "File_type", "File_count"
FROM (
    SELECT "extension", COUNT(*) AS "File_count"
    FROM (
        SELECT
            CASE
                WHEN "path" ILIKE '%.py' THEN '.py'
                WHEN "path" ILIKE '%.c' THEN '.c'
                WHEN "path" ILIKE '%.ipynb' THEN '.ipynb'
                WHEN "path" ILIKE '%.java' THEN '.java'
                WHEN "path" ILIKE '%.js' THEN '.js'
                ELSE NULL
            END AS "extension",
            "path"
        FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_FILES
        WHERE "path" LIKE '%/%/%/%/%/%/%/%/%/%/%'  -- directory depth greater than 10
    ) AS sub1
    WHERE "extension" IS NOT NULL
    GROUP BY "extension"
) AS sub2
ORDER BY "File_count" DESC NULLS LAST
LIMIT 1;