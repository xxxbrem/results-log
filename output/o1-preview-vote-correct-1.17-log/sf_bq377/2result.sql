SELECT
  req.KEY AS "package_name",
  COUNT(*) AS "frequency"
FROM
  GITHUB_REPOS.GITHUB_REPOS.SAMPLE_CONTENTS,
  LATERAL FLATTEN(INPUT => PARSE_JSON("content"):"require") req
WHERE
  "sample_path" = 'composer.json'
  AND "content" IS NOT NULL
GROUP BY
  "package_name"
ORDER BY
  "frequency" DESC NULLS LAST
;