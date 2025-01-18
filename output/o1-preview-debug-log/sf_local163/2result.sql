WITH avg_salaries AS (
    SELECT "FacRank", AVG("FacSalary") AS "AverageSalary"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
    GROUP BY "FacRank"
),
salary_differences AS (
    SELECT
        uf."FacRank",
        uf."FacFirstName",
        uf."FacLastName",
        ROUND(uf."FacSalary", 4) AS "FacSalary",
        ABS(uf."FacSalary" - avg_salaries."AverageSalary") AS "SalaryDifference"
    FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY uf
    JOIN avg_salaries ON uf."FacRank" = avg_salaries."FacRank"
),
ranked_salaries AS (
    SELECT
        sd.*,
        RANK() OVER (
            PARTITION BY sd."FacRank"
            ORDER BY sd."SalaryDifference" ASC, sd."FacFirstName", sd."FacLastName"
        ) AS "RankInGroup"
    FROM salary_differences sd
)
SELECT "FacRank", "FacFirstName", "FacLastName", "FacSalary"
FROM ranked_salaries
WHERE "RankInGroup" = 1
ORDER BY "FacRank";