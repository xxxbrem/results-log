WITH quinapril_concept_ids AS (
  SELECT "descendant_concept_id"
  FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT_ANCESTOR
  WHERE "ancestor_concept_id" = 1331235
  UNION
  SELECT 1331235 AS "descendant_concept_id"
),
total_participants AS (
  SELECT COUNT(DISTINCT "person_id") AS "total_count"
  FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON
),
non_quinapril_users AS (
  SELECT COUNT(DISTINCT p."person_id") AS "non_user_count"
  FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON p
  WHERE p."person_id" NOT IN (
    SELECT DISTINCT de."person_id"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.DRUG_EXPOSURE de
    WHERE de."drug_concept_id" IN (
      SELECT "descendant_concept_id"
      FROM quinapril_concept_ids
    )
  )
)
SELECT
  ROUND(non_quinapril_users."non_user_count" * 100.0 / total_participants."total_count", 4) AS "Percentage_Not_Using_Quinapril_and_Related_Medications"
FROM non_quinapril_users, total_participants;