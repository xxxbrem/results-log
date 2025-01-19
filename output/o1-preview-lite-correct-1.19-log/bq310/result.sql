SELECT title
FROM `bigquery-public-data.stackoverflow.posts_questions`
WHERE LOWER(title) LIKE '%how%' AND (
  tags LIKE '%android-layout%' OR
  tags LIKE '%android-activity%' OR
  tags LIKE '%android-intent%' OR
  tags LIKE '%android%' OR
  tags LIKE '%android-studio%' OR
  tags LIKE '%android-fragments%' OR
  tags LIKE '%android-recyclerview%' OR
  tags LIKE '%android-manifest%' OR
  tags LIKE '%android-gradle%' OR
  tags LIKE '%android-ndk%'
)
ORDER BY view_count DESC
LIMIT 1;