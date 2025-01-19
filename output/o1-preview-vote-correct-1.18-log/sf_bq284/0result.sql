SELECT "category",
       COUNT(*) AS "Total_Articles",
       ROUND((SUM(CASE WHEN "body" ILIKE '%education%' OR "title" ILIKE '%education%' THEN 1 ELSE 0 END)::FLOAT / COUNT(*)) * 100, 4) AS "Percentage_with_Education"
FROM BBC.BBC_NEWS.FULLTEXT
GROUP BY "category";