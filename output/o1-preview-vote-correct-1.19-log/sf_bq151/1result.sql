WITH high_quality_paad_patients AS (
    SELECT DISTINCT c."bcr_patient_barcode" AS "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP AS c
    INNER JOIN PANCANCER_ATLAS_2.PANCANCER_ATLAS.MERGED_SAMPLE_QUALITY_ANNOTATIONS AS q
        ON c."bcr_patient_barcode" = q."patient_barcode"
    WHERE c."acronym" = 'PAAD'
      AND (q."Do_not_use" IS NULL OR q."Do_not_use" != 'Yes')
),
patient_mutations AS (
    SELECT
        m."ParticipantBarcode",
        m."Hugo_Symbol"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE AS m
    WHERE m."Study" = 'PAAD'
),
mutations_per_patient AS (
    SELECT
        pm."ParticipantBarcode",
        MAX(CASE WHEN pm."Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS has_KRAS_mutation,
        MAX(CASE WHEN pm."Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS has_TP53_mutation
    FROM patient_mutations pm
    GROUP BY pm."ParticipantBarcode"
)
SELECT
    CASE WHEN mp.has_KRAS_mutation = 1 THEN 'Yes' ELSE 'No' END AS "KRAS_mutated",
    CASE WHEN mp.has_TP53_mutation = 1 THEN 'Yes' ELSE 'No' END AS "TP53_mutated",
    COUNT(*) AS "Count"
FROM high_quality_paad_patients hq
LEFT JOIN mutations_per_patient mp ON hq."ParticipantBarcode" = mp."ParticipantBarcode"
GROUP BY "KRAS_mutated", "TP53_mutated"
ORDER BY "KRAS_mutated" DESC NULLS LAST, "TP53_mutated" DESC NULLS LAST;