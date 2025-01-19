WITH paad_patients AS (
    SELECT DISTINCT c."bcr_patient_barcode" AS "Patient_Barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP" c
    INNER JOIN PANCANCER_ATLAS_2.PANCANCER_ATLAS."WHITELIST_PARTICIPANTBARCODES" w
        ON c."bcr_patient_barcode" = w."ParticipantBarcode"
    WHERE c."acronym" = 'PAAD'
),
kras_patients AS (
    SELECT DISTINCT m."ParticipantBarcode" AS "Patient_Barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
    WHERE m."Study" = 'PAAD' AND m."Hugo_Symbol" = 'KRAS' AND m."FILTER" = 'PASS'
),
tp53_patients AS (
    SELECT DISTINCT m."ParticipantBarcode" AS "Patient_Barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
    WHERE m."Study" = 'PAAD' AND m."Hugo_Symbol" = 'TP53' AND m."FILTER" = 'PASS'
),
mutation_status AS (
    SELECT 
        p."Patient_Barcode",
        CASE WHEN k."Patient_Barcode" IS NOT NULL THEN 'Positive' ELSE 'Negative' END AS "KRAS_mutation_status",
        CASE WHEN t."Patient_Barcode" IS NOT NULL THEN 'Positive' ELSE 'Negative' END AS "TP53_mutation_status"
    FROM paad_patients p
    LEFT JOIN kras_patients k ON p."Patient_Barcode" = k."Patient_Barcode"
    LEFT JOIN tp53_patients t ON p."Patient_Barcode" = t."Patient_Barcode"
)
SELECT 
    "KRAS_mutation_status",
    "TP53_mutation_status",
    COUNT(*) AS "Patient_Count"
FROM mutation_status
GROUP BY "KRAS_mutation_status", "TP53_mutation_status"
ORDER BY "KRAS_mutation_status" DESC NULLS LAST, "TP53_mutation_status" DESC NULLS LAST;