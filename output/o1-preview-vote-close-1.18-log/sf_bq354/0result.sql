WITH total_participants AS (
  SELECT COUNT(DISTINCT "person_id") AS total
  FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."PERSON"
),
condition_counts AS (
  SELECT
    CASE
      WHEN co."condition_source_value" LIKE '706%' THEN 'Acne (ICD-9 706.x)'
      WHEN co."condition_source_value" LIKE '691%' THEN 'Atopic dermatitis (ICD-9 691.x)'
      WHEN co."condition_source_value" LIKE '6961%' THEN 'Psoriasis (ICD-9 696.1)'
      WHEN co."condition_source_value" = '70901' THEN 'Vitiligo (ICD-9 709.01)'
      ELSE NULL
    END AS Condition,
    co."person_id"
  FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."CONDITION_OCCURRENCE" co
  WHERE co."condition_source_value" LIKE '706%'
     OR co."condition_source_value" LIKE '691%'
     OR co."condition_source_value" LIKE '6961%'
     OR co."condition_source_value" = '70901'
)
SELECT
  Condition,
  ROUND((COUNT(DISTINCT "person_id") * 100.0) / MAX(tp.total), 4) AS Percentage
FROM condition_counts cc
CROSS JOIN total_participants tp
WHERE Condition IS NOT NULL
GROUP BY Condition
ORDER BY Condition;