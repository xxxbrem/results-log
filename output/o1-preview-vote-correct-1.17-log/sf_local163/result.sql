WITH AverageSalaries AS (
    SELECT "FacRank", ROUND(AVG("FacSalary"), 4) AS "AvgSalary"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    GROUP BY "FacRank"
),
SalaryDifferences AS (
    SELECT 
        f."FacRank", 
        f."FacFirstName", 
        f."FacLastName",
        f."FacSalary",
        ABS(f."FacSalary" - a."AvgSalary") AS "SalaryDiff"
    FROM 
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
    JOIN 
        AverageSalaries a
    ON 
        f."FacRank" = a."FacRank"
),
MinDifferences AS (
    SELECT "FacRank", MIN("SalaryDiff") AS "MinSalaryDiff"
    FROM SalaryDifferences
    GROUP BY "FacRank"
)
SELECT 
    s."FacRank" AS "Rank", 
    s."FacFirstName" AS "FirstName", 
    s."FacLastName" AS "LastName", 
    s."FacSalary" AS "Salary"
FROM 
    SalaryDifferences s
JOIN 
    MinDifferences m
ON 
    s."FacRank" = m."FacRank" AND s."SalaryDiff" = m."MinSalaryDiff"
ORDER BY s."FacRank";