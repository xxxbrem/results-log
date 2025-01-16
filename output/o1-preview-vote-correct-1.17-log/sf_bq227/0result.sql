WITH total_crimes_per_year AS (
  SELECT "year", SUM("value") AS "total_crimes"
  FROM LONDON.LONDON_CRIME."CRIME_BY_LSOA"
  WHERE "year" >= 2008
  GROUP BY "year"
),
category_totals AS (
  SELECT 
    c."year", 
    c."minor_category", 
    SUM(c."value") AS "category_total"
  FROM LONDON.LONDON_CRIME."CRIME_BY_LSOA" c
  WHERE c."minor_category" IN (
    'Other Theft', 
    'Theft From Motor Vehicle', 
    'Possession Of Drugs', 
    'Burglary in a Dwelling', 
    'Assault with Injury'
  )
    AND c."year" >= 2008
  GROUP BY c."year", c."minor_category"
),
percentages AS (
  SELECT 
    ct."year",
    ct."minor_category",
    ROUND((ct."category_total" / tc."total_crimes") * 100, 4) AS "percentage_share"
  FROM category_totals ct
  JOIN total_crimes_per_year tc ON ct."year" = tc."year"
),
pivoted AS (
  SELECT
    p."year",
    'Other Theft' AS "Minor_Category_1_Name",
    MAX(CASE WHEN p."minor_category" = 'Other Theft' THEN p."percentage_share" ELSE NULL END) AS "Minor_Category_1_Percentage",
    'Theft From Motor Vehicle' AS "Minor_Category_2_Name",
    MAX(CASE WHEN p."minor_category" = 'Theft From Motor Vehicle' THEN p."percentage_share" ELSE NULL END) AS "Minor_Category_2_Percentage",
    'Possession Of Drugs' AS "Minor_Category_3_Name",
    MAX(CASE WHEN p."minor_category" = 'Possession Of Drugs' THEN p."percentage_share" ELSE NULL END) AS "Minor_Category_3_Percentage",
    'Burglary in a Dwelling' AS "Minor_Category_4_Name",
    MAX(CASE WHEN p."minor_category" = 'Burglary in a Dwelling' THEN p."percentage_share" ELSE NULL END) AS "Minor_Category_4_Percentage",
    'Assault with Injury' AS "Minor_Category_5_Name",
    MAX(CASE WHEN p."minor_category" = 'Assault with Injury' THEN p."percentage_share" ELSE NULL END) AS "Minor_Category_5_Percentage"
  FROM percentages p
  GROUP BY p."year"
)
SELECT *
FROM pivoted
ORDER BY "year";