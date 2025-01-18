WITH total_patients AS (
    SELECT "histological_type", COUNT(DISTINCT "bcr_patient_barcode") AS "total_patients"
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED"
    WHERE "acronym" = 'BRCA' AND "histological_type" IS NOT NULL AND "histological_type" != ''
    GROUP BY "histological_type"
),
cdh1_patients AS (
    SELECT DISTINCT m."ParticipantBarcode" AS "bcr_patient_barcode"
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
    WHERE m."Study" = 'BRCA' AND m."Hugo_Symbol" = 'CDH1'
),
cdh1_hist_types AS (
    SELECT c."histological_type", COUNT(DISTINCT c."bcr_patient_barcode") AS "cdh1_patients"
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED" c
    JOIN cdh1_patients p ON c."bcr_patient_barcode" = p."bcr_patient_barcode"
    WHERE c."acronym" = 'BRCA' AND c."histological_type" IS NOT NULL AND c."histological_type" != ''
    GROUP BY c."histological_type"
)
SELECT
    t."histological_type",
    ROUND((ch."cdh1_patients" * 100.0) / t."total_patients", 4) AS "Percentage_CDH1_Mutations"
FROM total_patients t
JOIN cdh1_hist_types ch ON t."histological_type" = ch."histological_type"
ORDER BY "Percentage_CDH1_Mutations" DESC NULLS LAST, t."histological_type"
LIMIT 5;