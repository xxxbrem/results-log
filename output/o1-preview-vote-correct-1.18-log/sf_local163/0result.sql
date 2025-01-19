WITH avg_salaries AS (
  SELECT "FacRank", ROUND(AVG("FacSalary"), 4) AS avg_salary
  FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY
  GROUP BY "FacRank"
),
fac_with_diff AS (
  SELECT 
    f."FacRank", 
    f."FacFirstName",
    f."FacLastName",
    ROUND(f."FacSalary", 4) AS "FacSalary",
    ABS(f."FacSalary" - a.avg_salary) AS salary_diff
  FROM EDUCATION_BUSINESS.EDUCATION_BUSINESS.UNIVERSITY_FACULTY f
  INNER JOIN avg_salaries a ON f."FacRank" = a."FacRank"
),
min_diff AS (
  SELECT "FacRank", MIN(salary_diff) AS min_salary_diff
  FROM fac_with_diff
  GROUP BY "FacRank"
)
SELECT 
  f."FacRank" AS Rank,
  f."FacFirstName" AS FirstName,
  f."FacLastName" AS LastName,
  f."FacSalary" AS Salary
FROM fac_with_diff f
INNER JOIN min_diff m ON f."FacRank" = m."FacRank" AND f.salary_diff = m.min_salary_diff
ORDER BY f."FacRank", f."FacLastName", f."FacFirstName";