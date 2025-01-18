WITH
    total_persons AS (
        SELECT COUNT(DISTINCT "person_id") AS total_persons
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.PERSON
    ),
    conditions AS (
        SELECT 'Acne (L70)' AS condition_name, 'L70' AS icd10_code
        UNION ALL
        SELECT 'Atopic dermatitis (L20)', 'L20'
        UNION ALL
        SELECT 'Psoriasis (L40)', 'L40'
        UNION ALL
        SELECT 'Vitiligo (L80)', 'L80'
    ),
    condition_concepts AS (
        SELECT c."concept_id", c."concept_name", conditions.condition_name
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT c
        JOIN conditions
            ON c."concept_code" LIKE conditions.icd10_code || '%'
        WHERE c."vocabulary_id" = 'ICD10CM'
    ),
    standard_concepts AS (
        SELECT cr."concept_id_2" AS standard_concept_id, condition_concepts.condition_name
        FROM condition_concepts
        JOIN CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONCEPT_RELATIONSHIP cr
            ON condition_concepts."concept_id" = cr."concept_id_1"
        WHERE cr."relationship_id" = 'Maps to'
    ),
    persons_with_conditions AS (
        SELECT DISTINCT co."person_id", sc.condition_name
        FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP.CONDITION_OCCURRENCE co
        JOIN standard_concepts sc
            ON co."condition_concept_id" = sc.standard_concept_id
    ),
    conditions_count AS (
        SELECT condition_name AS "Condition", COUNT(DISTINCT "person_id") AS person_count
        FROM persons_with_conditions
        GROUP BY condition_name
    )
SELECT
    cc."Condition",
    ROUND((cc.person_count::FLOAT / tp.total_persons) * 100, 4) AS "Percentage"
FROM
    conditions_count cc,
    total_persons tp
ORDER BY
    cc."Condition";