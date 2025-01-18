WITH avg_salary AS (
    SELECT "FacRank", AVG("FacSalary") AS "AvgSalary"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    WHERE "FacSalary" IS NOT NULL
    GROUP BY "FacRank"
),
diff_salary AS (
    SELECT 
        f."FacRank", 
        f."FacFirstName", 
        f."FacLastName", 
        f."FacSalary", 
        ABS(f."FacSalary" - avg."AvgSalary") AS "SalaryDiff",
        ROW_NUMBER() OVER (
            PARTITION BY f."FacRank" 
            ORDER BY ABS(f."FacSalary" - avg."AvgSalary") ASC, f."FacNo" ASC
        ) AS rn
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
    JOIN avg_salary avg ON f."FacRank" = avg."FacRank"
    WHERE f."FacSalary" IS NOT NULL
)
SELECT 
    d."FacRank" AS "Rank",
    d."FacFirstName" AS "FirstName",
    d."FacLastName" AS "LastName",
    TO_DECIMAL(d."FacSalary", 38, 4) AS "Salary"
FROM diff_salary d
WHERE d.rn = 1
ORDER BY d."FacRank";