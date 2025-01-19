SELECT "sample_repo_name" AS "Repository_name"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_CONTENTS
WHERE "binary" = FALSE AND "sample_path" LIKE '%.swift' AND "copies" = (
    SELECT MAX("copies")
    FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_CONTENTS
    WHERE "binary" = FALSE AND "sample_path" LIKE '%.swift'
)
LIMIT 1;