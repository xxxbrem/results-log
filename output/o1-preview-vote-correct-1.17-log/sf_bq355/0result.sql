SELECT
  ROUND(
    (
      (
        Total."total_participants" - QuinaprilUsers."participants_using_quinapril"
      ) * 100.0 / Total."total_participants"
    ), 4
  ) AS "percentage_of_participants_not_using_quinapril"
FROM
  (
    SELECT COUNT(DISTINCT "person_id") AS "total_participants"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."PERSON"
  ) Total,
  (
    SELECT COUNT(DISTINCT DE."person_id") AS "participants_using_quinapril"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."DRUG_EXPOSURE" DE
    WHERE DE."drug_concept_id" IN (
      SELECT "descendant_concept_id"
      FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."CONCEPT_ANCESTOR"
      WHERE "ancestor_concept_id" = (
        SELECT "concept_id"
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."CONCEPT"
        WHERE "concept_code" = '35208' AND "vocabulary_id" = 'RxNorm'
      )
    )
  ) QuinaprilUsers;