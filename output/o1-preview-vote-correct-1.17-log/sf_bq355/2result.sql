SELECT
    ROUND(
        100.0 * (
            (total.total_participants - users.users_of_quinapril_related_medications) 
            / total.total_participants
        ),
        4
    ) AS "Percentage_not_using_quinapril_and_related_medications"
FROM
    (
        SELECT COUNT(DISTINCT "person_id") AS total_participants
        FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."PERSON"
    ) total,
    (
        SELECT COUNT(DISTINCT "person_id") AS users_of_quinapril_related_medications
        FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."DRUG_EXPOSURE"
        WHERE "drug_concept_id" IN (
            SELECT DISTINCT "descendant_concept_id"
            FROM "CMS_DATA"."CMS_SYNTHETIC_PATIENT_DATA_OMOP"."CONCEPT_ANCESTOR"
            WHERE "ancestor_concept_id" = 1331235
        )
    ) users;