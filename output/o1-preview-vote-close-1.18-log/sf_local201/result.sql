WITH filtered_words AS (
  SELECT
    "words",
    LOWER("words") AS word_lower
  FROM "MODERN_DATA"."MODERN_DATA"."WORD_LIST"
  WHERE LOWER("words") LIKE 'r%' AND LENGTH("words") BETWEEN 4 AND 5
),
word_signatures AS (
  SELECT
    "words",
    ARRAY_TO_STRING(ARRAY_SORT(REGEXP_SUBSTR_ALL(word_lower, '.')), '') AS sorted_letters
  FROM filtered_words
),
anagram_counts AS (
  SELECT
    sorted_letters,
    COUNT(*) AS Anagram_Count
  FROM word_signatures
  GROUP BY sorted_letters
  HAVING COUNT(*) > 1
),
final_result AS (
  SELECT
    ws."words" AS Word,
    ac.Anagram_Count
  FROM word_signatures ws
  JOIN anagram_counts ac ON ws.sorted_letters = ac.sorted_letters
)
SELECT
  Word,
  Anagram_Count
FROM final_result
ORDER BY Word
LIMIT 10;