WITH all_words AS (
  SELECT LOWER("words") AS word
  FROM MODERN_DATA.MODERN_DATA.WORD_LIST
),
sorted_words AS (
  SELECT
    word,
    ARRAY_TO_STRING(ARRAY_SORT(SPLIT(word, '')), '') AS sorted_word
  FROM all_words
),
anagram_groups AS (
  SELECT
    sorted_word,
    COUNT(*) AS anagram_count
  FROM sorted_words
  GROUP BY sorted_word
  HAVING COUNT(*) > 1
),
selected_words AS (
  SELECT
    sw.word,
    ag.anagram_count - 1 AS anagram_count
  FROM sorted_words sw
  JOIN anagram_groups ag ON sw.sorted_word = ag.sorted_word
  WHERE LENGTH(sw.word) BETWEEN 4 AND 5 AND sw.word LIKE 'r%'
)
SELECT
  word AS "Word",
  anagram_count AS "Anagram_Count"
FROM selected_words
ORDER BY word ASC
LIMIT 10;