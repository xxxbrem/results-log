WITH article_words AS (
    SELECT
        n."id" AS "article_id",
        LOWER(word.value::string) AS "word"
    FROM
        "WORD_VECTORS_US"."WORD_VECTORS_US"."NATURE" n,
        LATERAL SPLIT_TO_TABLE(REGEXP_REPLACE(n."body",'[^a-zA-Z]', ' '), ' ') word
    WHERE
        TRIM(word.value) <> ''
),
word_vectors AS (
    SELECT
        aw."article_id",
        aw."word",
        gv."vector" AS "word_vector",
        wf."frequency"
    FROM
        article_words aw
        JOIN "WORD_VECTORS_US"."WORD_VECTORS_US"."GLOVE_VECTORS" gv ON aw."word" = gv."word"
        JOIN "WORD_VECTORS_US"."WORD_VECTORS_US"."WORD_FREQUENCIES" wf ON aw."word" = wf."word"
),
weighted_word_vectors AS (
    SELECT
        "article_id",
        "word",
        POWER("frequency", 0.4) AS "weight",
        "word_vector"
    FROM word_vectors
),
flattened_vectors AS (
    SELECT
        "article_id",
        f."INDEX" AS "vector_index",
        (f."VALUE"::FLOAT) * "weight" AS "weighted_val"
    FROM
        weighted_word_vectors,
        LATERAL FLATTEN(input => "word_vector") f
),
article_vector_components AS (
    SELECT
        "article_id",
        "vector_index",
        SUM("weighted_val") AS "component_val"
    FROM flattened_vectors
    GROUP BY "article_id", "vector_index"
),
article_vector_norms AS (
    SELECT
        "article_id",
        SQRT(SUM(POW("component_val", 2))) AS "norm"
    FROM article_vector_components
    GROUP BY "article_id"
),
normalized_article_vectors AS (
    SELECT
        avc."article_id",
        avc."vector_index",
        avc."component_val" / avn."norm" AS "normalized_val"
    FROM
        article_vector_components avc
        JOIN article_vector_norms avn ON avc."article_id" = avn."article_id"
),
target_article_vector AS (
    SELECT *
    FROM normalized_article_vectors
    WHERE "article_id" = '8a78ef2d-d5f7-4d2d-9b47-5adb25cbd373'
),
cosine_similarities AS (
    SELECT
        nav."article_id",
        SUM(nav."normalized_val" * tav."normalized_val") AS "similarity_score"
    FROM
        normalized_article_vectors nav
        JOIN target_article_vector tav ON nav."vector_index" = tav."vector_index"
    WHERE
        nav."article_id" <> '8a78ef2d-d5f7-4d2d-9b47-5adb25cbd373'
    GROUP BY nav."article_id"
)
SELECT
    cs."article_id" AS "id",
    n."date",
    n."title",
    ROUND(cs."similarity_score", 4) AS "similarity_score"
FROM
    cosine_similarities cs
    JOIN "WORD_VECTORS_US"."WORD_VECTORS_US"."NATURE" n ON cs."article_id" = n."id"
ORDER BY
    cs."similarity_score" DESC NULLS LAST
LIMIT 10;