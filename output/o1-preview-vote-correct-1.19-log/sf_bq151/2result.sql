WITH patients_to_exclude AS (
  SELECT DISTINCT "patient_barcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."MERGED_SAMPLE_QUALITY_ANNOTATIONS"
  WHERE "Do_not_use" IN ('True', '1', '1.0')
),
paad_patients AS (
  SELECT DISTINCT c."bcr_patient_barcode" AS "patient_barcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP" c
  WHERE c."acronym" = 'PAAD'
),
high_quality_paad_patients AS (
  SELECT p."patient_barcode"
  FROM paad_patients p
  LEFT JOIN patients_to_exclude pte
    ON p."patient_barcode" = pte."patient_barcode"
  WHERE pte."patient_barcode" IS NULL
),
kras_mutations AS (
  SELECT DISTINCT m."ParticipantBarcode" AS "patient_barcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
  WHERE m."Hugo_Symbol" = 'KRAS' AND UPPER(m."FILTER") = 'PASS'
),
tp53_mutations AS (
  SELECT DISTINCT m."ParticipantBarcode" AS "patient_barcode"
  FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS."FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE" m
  WHERE m."Hugo_Symbol" = 'TP53' AND UPPER(m."FILTER") = 'PASS'
),
patient_mutation_status AS (
  SELECT
    hqpp."patient_barcode",
    CASE WHEN k."patient_barcode" IS NOT NULL THEN 'Yes' ELSE 'No' END AS KRAS_mutated,
    CASE WHEN t."patient_barcode" IS NOT NULL THEN 'Yes' ELSE 'No' END AS TP53_mutated
  FROM high_quality_paad_patients hqpp
  LEFT JOIN kras_mutations k ON hqpp."patient_barcode" = k."patient_barcode"
  LEFT JOIN tp53_mutations t ON hqpp."patient_barcode" = t."patient_barcode"
)
SELECT KRAS_mutated, TP53_mutated, COUNT(*) AS "Count"
FROM patient_mutation_status
GROUP BY KRAS_mutated, TP53_mutated
ORDER BY KRAS_mutated DESC NULLS LAST, TP53_mutated DESC NULLS LAST;