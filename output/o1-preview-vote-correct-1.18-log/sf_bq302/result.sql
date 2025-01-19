SELECT
    TO_CHAR(TO_TIMESTAMP("creation_date" / 1000000), 'MM') AS "Month_num",
    TO_CHAR(TO_TIMESTAMP("creation_date" / 1000000), 'Mon') AS "Month",
    ROUND(COUNT(CASE WHEN "tags" ILIKE '%python%' THEN 1 END)::float / COUNT(*), 4) AS "Proportion"
FROM
    "STACKOVERFLOW"."STACKOVERFLOW"."POSTS_QUESTIONS"
WHERE
    TO_CHAR(TO_TIMESTAMP("creation_date" / 1000000), 'YYYY') = '2022'
GROUP BY
    "Month_num", "Month"
ORDER BY
    "Month_num";