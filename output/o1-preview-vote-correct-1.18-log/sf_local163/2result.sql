WITH avg_salaries AS (
    SELECT 
        "FacRank",
        AVG("FacSalary") AS "AvgSalary"
    FROM 
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."UNIVERSITY_FACULTY"
    GROUP BY 
        "FacRank"
),
faculty_diffs AS (
    SELECT
        f."FacRank",
        f."FacFirstName",
        f."FacLastName",
        f."FacSalary",
        ABS(f."FacSalary" - avg_s."AvgSalary") AS "SalaryDiff"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."UNIVERSITY_FACULTY" f
    JOIN
        avg_salaries avg_s ON f."FacRank" = avg_s."FacRank"
)
SELECT
    sub."FacRank",
    sub."FacFirstName",
    sub."FacLastName",
    TO_CHAR(sub."FacSalary", 'FM99999999.0000') AS "FacSalary"
FROM (
    SELECT
        fd.*,
        ROW_NUMBER() OVER (
            PARTITION BY fd."FacRank"
            ORDER BY fd."SalaryDiff" ASC
        ) AS rn
    FROM
        faculty_diffs fd
) sub
WHERE rn = 1;