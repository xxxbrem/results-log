SELECT TOP 1 "File_type", "File_count"
FROM (
    SELECT
        CASE
            WHEN "path" ILIKE '%.py' THEN '.py'
            WHEN "path" ILIKE '%.c' THEN '.c'
            WHEN "path" ILIKE '%.ipynb' THEN '.ipynb'
            WHEN "path" ILIKE '%.java' THEN '.java'
            WHEN "path" ILIKE '%.js' THEN '.js'
        END AS "File_type",
        COUNT(*) AS "File_count"
    FROM
        "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_FILES"
    WHERE
        (LENGTH("path") - LENGTH(REPLACE("path", '/', ''))) > 10
        AND (
            "path" ILIKE '%.py' OR
            "path" ILIKE '%.c' OR
            "path" ILIKE '%.ipynb' OR
            "path" ILIKE '%.java' OR
            "path" ILIKE '%.js'
        )
    GROUP BY
        "File_type"
) AS counts
ORDER BY
    "File_count" DESC NULLS LAST,
    "File_type" ASC
;