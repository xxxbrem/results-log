WITH avg_salary AS (
    SELECT "FacRank", ROUND(AVG("FacSalary"), 4) AS "AvgSalary"
    FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."UNIVERSITY_FACULTY"
    GROUP BY "FacRank"
),
salary_diff AS (
    SELECT 
        uf."FacRank", 
        uf."FacFirstName", 
        uf."FacLastName", 
        uf."FacSalary",
        ROUND(ABS(uf."FacSalary" - avg_salary."AvgSalary"), 4) AS "SalaryDiff"
    FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."UNIVERSITY_FACULTY" uf
    JOIN avg_salary 
        ON uf."FacRank" = avg_salary."FacRank"
),
min_salary_diff AS (
    SELECT "FacRank", MIN("SalaryDiff") AS "MinSalaryDiff"
    FROM salary_diff
    GROUP BY "FacRank"
)
SELECT 
    sd."FacRank" AS "Rank", 
    sd."FacFirstName" AS "FirstName", 
    sd."FacLastName" AS "LastName", 
    sd."FacSalary" AS "Salary"
FROM salary_diff sd
JOIN min_salary_diff msd
    ON sd."FacRank" = msd."FacRank" 
    AND sd."SalaryDiff" = msd."MinSalaryDiff"
ORDER BY sd."FacRank";