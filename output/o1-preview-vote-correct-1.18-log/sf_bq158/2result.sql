WITH total_patients AS (
    SELECT "histological_type", COUNT(DISTINCT "bcr_patient_barcode") AS "total_patients"
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED"
    WHERE "acronym" = 'BRCA' AND "histological_type" IS NOT NULL AND "histological_type" <> ''
    GROUP BY "histological_type"
),
patients_with_cdh1 AS (
    SELECT c."histological_type", COUNT(DISTINCT c."bcr_patient_barcode") AS "patients_with_cdh1_mutations"
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED" c
    INNER JOIN (
        SELECT DISTINCT "ParticipantBarcode" AS "bcr_patient_barcode"
        FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
        WHERE "Study" = 'BRCA' AND "Hugo_Symbol" = 'CDH1'
    ) m
    ON c."bcr_patient_barcode" = m."bcr_patient_barcode"
    WHERE c."acronym" = 'BRCA' AND c."histological_type" IS NOT NULL AND c."histological_type" <> ''
    GROUP BY c."histological_type"
)
SELECT t."histological_type",
       ROUND(
           COALESCE(p."patients_with_cdh1_mutations", 0) * 100.0 / t."total_patients", 4
       ) AS percentage
FROM total_patients t
LEFT JOIN patients_with_cdh1 p
ON t."histological_type" = p."histological_type"
ORDER BY percentage DESC NULLS LAST
LIMIT 5;