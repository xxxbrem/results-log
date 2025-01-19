WITH
  total_participants AS (
    SELECT COUNT(DISTINCT "person_id") AS total_count
    FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."PERSON"
  ),
  quinapril_concepts AS (
    SELECT DISTINCT "descendant_concept_id" AS "concept_id"
    FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."CONCEPT_ANCESTOR"
    WHERE "ancestor_concept_id" = 1331235
  ),
  users_of_quinapril AS (
    SELECT COUNT(DISTINCT de."person_id") AS user_count
    FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."DRUG_EXPOSURE" de
    JOIN quinapril_concepts qc ON de."drug_concept_id" = qc."concept_id"
  )
SELECT
  ROUND(100.0 * (tp.total_count - uq.user_count) / tp.total_count, 4) AS "percentage_not_using_quinapril"
FROM total_participants tp, users_of_quinapril uq;