SELECT r.key AS package_name, COUNT(*) AS frequency
FROM "GITHUB_REPOS"."GITHUB_REPOS"."SAMPLE_CONTENTS",
     LATERAL FLATTEN(input => TRY_PARSE_JSON("content"):require) r
WHERE ("sample_path" ILIKE '%package.json%' OR "sample_path" ILIKE '%composer.json%')
  AND TRY_PARSE_JSON("content"):require IS NOT NULL
GROUP BY package_name
ORDER BY frequency DESC NULLS LAST;