WITH total_participants AS (
    SELECT COUNT(*) AS total
    FROM CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."PERSON"
),
conditions AS (
    SELECT
        CASE
            WHEN c."condition_source_value" LIKE '706%' THEN 'Acne'
            WHEN c."condition_source_value" LIKE '691%' THEN 'Atopic dermatitis'
            WHEN c."condition_source_value" LIKE '696%' THEN 'Psoriasis'
            WHEN c."condition_source_value" LIKE '70901' THEN 'Vitiligo'
        END AS Condition,
        c."person_id"
    FROM
        CMS_DATA.CMS_SYNTHETIC_PATIENT_DATA_OMOP."CONDITION_OCCURRENCE" c
    WHERE
        c."condition_source_value" LIKE '706%'
        OR c."condition_source_value" LIKE '691%'
        OR c."condition_source_value" LIKE '696%'
        OR c."condition_source_value" = '70901'
)
SELECT
    Condition,
    ROUND((COUNT(DISTINCT "person_id") * 100.0) / (SELECT total FROM total_participants), 4) AS Percentage
FROM
    conditions
WHERE
    Condition IS NOT NULL
GROUP BY
    Condition
ORDER BY
    Condition;