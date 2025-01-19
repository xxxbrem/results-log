WITH avg_salary_per_rank AS (
    SELECT "FacRank", ROUND(AVG("FacSalary"), 4) AS "AvgSalary"
    FROM "university_faculty"
    GROUP BY "FacRank"
),
salary_diff AS (
    SELECT
        uf."FacRank",
        uf."FacFirstName",
        uf."FacLastName",
        uf."FacSalary",
        ROUND(ABS(uf."FacSalary" - avg_rank."AvgSalary"), 4) AS "SalaryDiff"
    FROM "university_faculty" uf
    JOIN avg_salary_per_rank avg_rank ON uf."FacRank" = avg_rank."FacRank"
),
min_diff_per_rank AS (
    SELECT "FacRank", MIN("SalaryDiff") AS "MinDiff"
    FROM salary_diff
    GROUP BY "FacRank"
)
SELECT s."FacRank", s."FacFirstName", s."FacLastName", s."FacSalary"
FROM salary_diff s
JOIN min_diff_per_rank m ON s."FacRank" = m."FacRank" AND s."SalaryDiff" = m."MinDiff"
ORDER BY s."FacRank";