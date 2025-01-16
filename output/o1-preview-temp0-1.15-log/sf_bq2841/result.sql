SELECT
    CASE
        WHEN "category" = 'business' THEN 'Business'
        WHEN "category" = 'tech' THEN 'Technology'
        WHEN "category" = 'sport' THEN 'Sports'
        WHEN "category" = 'politics' THEN 'Politics'
        WHEN "category" = 'entertainment' THEN 'Entertainment'
        ELSE "category"
    END AS category,
    COUNT(*) AS total_articles,
    ROUND(
        (COUNT(CASE WHEN "body" LIKE '%education%' OR "title" LIKE '%education%' THEN 1 END) * 100.0) / COUNT(*),
        4
    ) AS percentage_mentioning_education
FROM BBC.BBC_NEWS.FULLTEXT
GROUP BY
    CASE
        WHEN "category" = 'business' THEN 'Business'
        WHEN "category" = 'tech' THEN 'Technology'
        WHEN "category" = 'sport' THEN 'Sports'
        WHEN "category" = 'politics' THEN 'Politics'
        WHEN "category" = 'entertainment' THEN 'Entertainment'
        ELSE "category"
    END;