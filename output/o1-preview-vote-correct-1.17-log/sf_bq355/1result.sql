WITH total_participants AS (
    SELECT COUNT(DISTINCT "person_id") AS total
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON
),
quinapril_concept_id AS (
    SELECT "concept_id"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT
    WHERE "concept_code" = '35208' AND "vocabulary_id" = 'RxNorm'
),
quinapril_related_concept_ids AS (
    SELECT "descendant_concept_id"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT_ANCESTOR
    WHERE "ancestor_concept_id" = (SELECT "concept_id" FROM quinapril_concept_id)
),
participants_using_quinapril AS (
    SELECT DISTINCT de."person_id"
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.DRUG_EXPOSURE de
    WHERE de."drug_concept_id" IN (SELECT "descendant_concept_id" FROM quinapril_related_concept_ids)
)
SELECT
    ROUND(
        100.0 * (1 - ((SELECT COUNT(*) FROM participants_using_quinapril)::FLOAT / (SELECT total FROM total_participants))),
        4
    ) AS "percentage_not_using_quinapril_or_related_medications";