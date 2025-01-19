SELECT
  ROUND(
    (
      (
        SELECT COUNT(DISTINCT "person_id")
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON
      ) -
      (
        SELECT COUNT(DISTINCT de."person_id")
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.DRUG_EXPOSURE de
        WHERE de."drug_concept_id" IN (
          SELECT "descendant_concept_id"
          FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT_ANCESTOR
          WHERE "ancestor_concept_id" = 1331235
        )
      )
    ) * 100.0 /
    (
      SELECT COUNT(DISTINCT "person_id")
      FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON
    ), 4
  ) AS "Percentage_not_using";