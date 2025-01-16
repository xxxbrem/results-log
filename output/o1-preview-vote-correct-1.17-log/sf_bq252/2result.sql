SELECT 
  "sample_repo_name" AS "repo_name", 
  "id" AS "file_id", 
  "copies"
FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_CONTENTS
WHERE "binary" = FALSE 
  AND "sample_path" LIKE '%.swift' 
  AND "copies" = (
    SELECT MAX("copies")
    FROM GITHUB_REPOS.GITHUB_REPOS.SAMPLE_CONTENTS
    WHERE "binary" = FALSE AND "sample_path" LIKE '%.swift'
  );