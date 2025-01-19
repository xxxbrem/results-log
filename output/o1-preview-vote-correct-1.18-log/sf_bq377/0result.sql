SELECT
    k.KEY AS "package_name",
    COUNT(*) AS "frequency"
FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_CONTENTS",
     LATERAL FLATTEN(INPUT => TRY_PARSE_JSON("content"):"require") k
WHERE
    ("sample_path" ILIKE '%package.json' OR "sample_path" ILIKE '%composer.json')
    AND "binary" = FALSE
    AND TRY_PARSE_JSON("content") IS NOT NULL
    AND TRY_PARSE_JSON("content"):"require" IS NOT NULL
GROUP BY k.KEY
ORDER BY "frequency" DESC NULLS LAST;