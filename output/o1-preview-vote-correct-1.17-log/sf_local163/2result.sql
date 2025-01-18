WITH AvgSalary AS (
    SELECT "FacRank", AVG("FacSalary") AS "AverageSalary"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    GROUP BY "FacRank"
),
SalaryDifferences AS (
    SELECT 
        f."FacRank",
        f."FacFirstName",
        f."FacLastName",
        f."FacSalary",
        ABS(f."FacSalary" - a."AverageSalary") AS "SalaryDifference",
        ROW_NUMBER() OVER (
            PARTITION BY f."FacRank" 
            ORDER BY ABS(f."FacSalary" - a."AverageSalary") ASC, f."FacLastName", f."FacFirstName"
        ) AS rn
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
    JOIN AvgSalary a ON f."FacRank" = a."FacRank"
)
SELECT
    CASE 
        WHEN sd."FacRank" = 'ASST' THEN 'Assistant Professor'
        WHEN sd."FacRank" = 'ASSC' THEN 'Associate Professor'
        WHEN sd."FacRank" = 'PROF' THEN 'Professor'
        ELSE sd."FacRank"
    END AS "Rank",
    sd."FacFirstName" AS "FirstName",
    sd."FacLastName" AS "LastName",
    ROUND(sd."FacSalary", 4) AS "Salary"
FROM SalaryDifferences sd
WHERE sd.rn = 1
ORDER BY 1;