WITH AvgSalaryPerRank AS (
    SELECT "FacRank", AVG("FacSalary") AS "AvgSalary"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    GROUP BY "FacRank"
),
FacultySalaryDifference AS (
    SELECT 
        f."FacRank" AS "Rank", 
        f."FacFirstName" AS "FirstName",
        f."FacLastName" AS "LastName",
        f."FacSalary" AS "Salary", 
        ABS(f."FacSalary" - a."AvgSalary") AS "SalaryDifference"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
    JOIN AvgSalaryPerRank a ON f."FacRank" = a."FacRank"
),
MinDifferencePerRank AS (
    SELECT "Rank", MIN("SalaryDifference") AS "MinDifference"
    FROM FacultySalaryDifference
    GROUP BY "Rank"
)
SELECT f."Rank", f."FirstName", f."LastName", ROUND(f."Salary", 4) AS "Salary"
FROM FacultySalaryDifference f
JOIN MinDifferencePerRank m 
    ON f."Rank" = m."Rank" AND f."SalaryDifference" = m."MinDifference"
ORDER BY f."Rank", f."LastName", f."FirstName";