WITH AvgSalaryPerRank AS (
    SELECT
        "FacRank",
        AVG("FacSalary") AS "AverageSalary"
    FROM
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    GROUP BY
        "FacRank"
),
FacultyWithDifference AS (
    SELECT
        F."FacRank",
        F."FacFirstName",
        F."FacLastName",
        F."FacSalary",
        A."AverageSalary",
        ABS(F."FacSalary" - A."AverageSalary") AS "SalaryDifference"
    FROM
        EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY F
        INNER JOIN AvgSalaryPerRank A ON F."FacRank" = A."FacRank"
),
RankedFaculty AS (
    SELECT
        F.*,
        ROW_NUMBER() OVER (
            PARTITION BY F."FacRank"
            ORDER BY "SalaryDifference" ASC, F."FacSalary" ASC
        ) AS "RowNum"
    FROM
        FacultyWithDifference F
)
SELECT
    CASE "FacRank"
        WHEN 'ASST' THEN 'Assistant Professor'
        WHEN 'ASSC' THEN 'Associate Professor'
        WHEN 'PROF' THEN 'Professor'
        ELSE "FacRank"
    END AS "FacRank",
    "FacFirstName",
    "FacLastName",
    TO_CHAR("FacSalary", 'FM999999999.0000') AS "FacSalary"
FROM
    RankedFaculty
WHERE
    "RowNum" = 1;