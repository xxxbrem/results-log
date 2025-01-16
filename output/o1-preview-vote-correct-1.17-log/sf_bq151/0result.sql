WITH paad_patients AS (
    SELECT DISTINCT p."ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.BARCODEMAP p
    WHERE p."Study" = 'PAAD'
),
high_quality_patients AS (
    SELECT DISTINCT q."patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.MERGED_SAMPLE_QUALITY_ANNOTATIONS q
    WHERE (q."patient_annotation" IS NULL OR q."patient_annotation" = '')
      AND (q."aliquot_annotation" IS NULL OR q."aliquot_annotation" = '')
),
patients_with_clinical_data AS (
    SELECT DISTINCT c."bcr_patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP c
    WHERE c."acronym" = 'PAAD'
),
final_patients AS (
    SELECT p."ParticipantBarcode"
    FROM paad_patients p
    INNER JOIN high_quality_patients q ON p."ParticipantBarcode" = q."patient_barcode"
    INNER JOIN patients_with_clinical_data c ON p."ParticipantBarcode" = c."bcr_patient_barcode"
),
patients_with_KRAS AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS'
),
patients_with_TP53 AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53'
),
mutation_flags AS (
    SELECT p."ParticipantBarcode",
           CASE WHEN k."ParticipantBarcode" IS NOT NULL THEN 1 ELSE 0 END AS has_KRAS_mut,
           CASE WHEN t."ParticipantBarcode" IS NOT NULL THEN 1 ELSE 0 END AS has_TP53_mut
    FROM final_patients p
    LEFT JOIN patients_with_KRAS k ON p."ParticipantBarcode" = k."ParticipantBarcode"
    LEFT JOIN patients_with_TP53 t ON p."ParticipantBarcode" = t."ParticipantBarcode"
),
counts AS (
    SELECT
        SUM(CASE WHEN has_KRAS_mut = 1 AND has_TP53_mut = 1 THEN 1 ELSE 0 END) AS both_mutated,
        SUM(CASE WHEN has_KRAS_mut = 1 AND has_TP53_mut = 0 THEN 1 ELSE 0 END) AS KRAS_only,
        SUM(CASE WHEN has_KRAS_mut = 0 AND has_TP53_mut = 1 THEN 1 ELSE 0 END) AS TP53_only,
        SUM(CASE WHEN has_KRAS_mut = 0 AND has_TP53_mut = 0 THEN 1 ELSE 0 END) AS neither_mutated,
        COUNT(*) AS total_patients
    FROM mutation_flags
),
expected_counts AS (
    SELECT
        c.*,
        (KRAS_mutated_total::FLOAT * TP53_mutated_total::FLOAT) / total_patients AS E_both_mutated,
        (KRAS_mutated_total::FLOAT * (total_patients - TP53_mutated_total)::FLOAT) / total_patients AS E_KRAS_only,
        ((total_patients - KRAS_mutated_total)::FLOAT * TP53_mutated_total::FLOAT) / total_patients AS E_TP53_only,
        ((total_patients - KRAS_mutated_total)::FLOAT * (total_patients - TP53_mutated_total)::FLOAT) / total_patients AS E_neither_mutated
    FROM (
        SELECT
            both_mutated,
            KRAS_only,
            TP53_only,
            neither_mutated,
            total_patients,
            (both_mutated + KRAS_only) AS KRAS_mutated_total,
            (both_mutated + TP53_only) AS TP53_mutated_total
        FROM counts
    ) c
),
chi_squared_stat AS (
    SELECT
        ROUND((
            ((both_mutated - E_both_mutated)*(both_mutated - E_both_mutated))/E_both_mutated +
            ((KRAS_only - E_KRAS_only)*(KRAS_only - E_KRAS_only))/E_KRAS_only +
            ((TP53_only - E_TP53_only)*(TP53_only - E_TP53_only))/E_TP53_only +
            ((neither_mutated - E_neither_mutated)*(neither_mutated - E_neither_mutated))/E_neither_mutated
        ), 4) AS chi_squared_statistic
    FROM expected_counts
)
SELECT chi_squared_statistic
FROM chi_squared_stat;