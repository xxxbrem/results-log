WITH ranked_causes AS (
  SELECT
    SUBSTR("collision_date", 1, 4) AS Year,
    "pcf_violation_category",
    COUNT(*) as cnt,
    RANK() OVER (PARTITION BY SUBSTR("collision_date", 1, 4) ORDER BY COUNT(*) DESC) AS rank
  FROM "collisions"
  WHERE "collision_date" IS NOT NULL AND "collision_date" != ''
    AND "pcf_violation_category" IS NOT NULL AND "pcf_violation_category" != ''
  GROUP BY Year, "pcf_violation_category"
),
per_year_top2 AS (
  SELECT
    Year,
    "pcf_violation_category"
  FROM ranked_causes
  WHERE rank <= 2
),
per_year_top2_ordered AS (
  SELECT
    Year,
    GROUP_CONCAT("pcf_violation_category", '|') AS top2_causes
  FROM (
    SELECT Year, "pcf_violation_category"
    FROM per_year_top2
    ORDER BY Year, "pcf_violation_category"
  )
  GROUP BY Year
),
top2_counts AS (
  SELECT top2_causes, COUNT(*) as years_with_this_top2
  FROM per_year_top2_ordered
  GROUP BY top2_causes
)
SELECT per_year_top2_ordered.Year
FROM per_year_top2_ordered
JOIN top2_counts ON per_year_top2_ordered.top2_causes = top2_counts.top2_causes
WHERE top2_counts.years_with_this_top2 = 1;