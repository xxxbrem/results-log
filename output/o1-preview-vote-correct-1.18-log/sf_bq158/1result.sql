WITH total_patients AS (
    SELECT "histological_type", COUNT(DISTINCT "bcr_patient_barcode") AS total_patients
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED"
    WHERE "acronym" = 'BRCA' AND "histological_type" IS NOT NULL AND "histological_type" != ''
    GROUP BY "histological_type"
),
cdh1_patients AS (
    SELECT c."histological_type", COUNT(DISTINCT c."bcr_patient_barcode") AS cdh1_patients
    FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP_FILTERED" c
    JOIN (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_1.PANCANCER_ATLAS_FILTERED."MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE"
        WHERE "Study" = 'BRCA' AND "Hugo_Symbol" = 'CDH1'
    ) m ON c."bcr_patient_barcode" = m."ParticipantBarcode"
    WHERE c."acronym" = 'BRCA' AND c."histological_type" IS NOT NULL AND c."histological_type" != ''
    GROUP BY c."histological_type"
)
SELECT
    t."histological_type" AS Histological_Type,
    ROUND((COALESCE(c.cdh1_patients, 0) * 100.0) / t.total_patients, 4) AS Percentage_of_CDH1_Mutations
FROM total_patients t
LEFT JOIN cdh1_patients c ON t."histological_type" = c."histological_type"
ORDER BY Percentage_of_CDH1_Mutations DESC NULLS LAST
LIMIT 5;