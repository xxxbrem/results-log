WITH paad_patients AS (
    SELECT DISTINCT p."bcr_patient_barcode" AS "ParticipantBarcode"
    FROM "PANCANCER_ATLAS_2"."PANCANCER_ATLAS"."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP" p
    WHERE p."acronym" = 'PAAD'
),
high_quality_mutations AS (
    SELECT DISTINCT m."ParticipantBarcode", m."Hugo_Symbol"
    FROM "PANCANCER_ATLAS_2"."PANCANCER_ATLAS"."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
    INNER JOIN "PANCANCER_ATLAS_2"."PANCANCER_ATLAS"."MERGED_SAMPLE_QUALITY_ANNOTATIONS" q
    ON m."Tumor_AliquotBarcode" = q."aliquot_barcode"
    WHERE m."Study" = 'PAAD' AND q."Do_not_use" = '0'
),
kras_mutations AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM high_quality_mutations
    WHERE "Hugo_Symbol" = 'KRAS'
),
tp53_mutations AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM high_quality_mutations
    WHERE "Hugo_Symbol" = 'TP53'
)
SELECT 
    CASE WHEN k."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END AS "KRAS_mutation_status",
    CASE WHEN t."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END AS "TP53_mutation_status",
    COUNT(DISTINCT p."ParticipantBarcode") AS "Patient_Count"
FROM paad_patients p
LEFT JOIN kras_mutations k ON p."ParticipantBarcode" = k."ParticipantBarcode"
LEFT JOIN tp53_mutations t ON p."ParticipantBarcode" = t."ParticipantBarcode"
GROUP BY 
    CASE WHEN k."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END,
    CASE WHEN t."ParticipantBarcode" IS NOT NULL THEN 'Mutated' ELSE 'Not Mutated' END;