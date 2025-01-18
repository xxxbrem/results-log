SELECT 
    CASE
        WHEN t."FacRank" = 'ASST' THEN 'Assistant Professor'
        WHEN t."FacRank" = 'ASSC' THEN 'Associate Professor'
        WHEN t."FacRank" = 'PROF' THEN 'Professor'
        ELSE t."FacRank"
    END AS "FacRank",
    t."FacFirstName",
    t."FacLastName",
    ROUND(t."FacSalary", 4) AS "FacSalary"
FROM (
    SELECT 
        f."FacRank",
        f."FacFirstName",
        f."FacLastName",
        f."FacSalary",
        ABS(f."FacSalary" - a.avg_salary) AS salary_diff,
        RANK() OVER (PARTITION BY f."FacRank" ORDER BY ABS(f."FacSalary" - a.avg_salary)) AS rk
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
    JOIN (
        SELECT "FacRank", AVG("FacSalary") AS avg_salary
        FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
        WHERE "FacSalary" IS NOT NULL AND "FacRank" IS NOT NULL
        GROUP BY "FacRank"
    ) a ON f."FacRank" = a."FacRank"
    WHERE f."FacSalary" IS NOT NULL AND f."FacRank" IS NOT NULL
) t
WHERE t.rk = 1;