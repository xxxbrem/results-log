SELECT 
    "category",
    COUNT(*) AS "total_articles",
    ROUND((SUM(CASE WHEN ("body" LIKE '%education%' OR "title" LIKE '%education%') THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 4) AS "percentage_with_education"
FROM BBC.BBC_NEWS.FULLTEXT
GROUP BY "category";