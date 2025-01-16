WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
excluded_patients AS (
    SELECT DISTINCT "patient_barcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.MERGED_SAMPLE_QUALITY_ANNOTATIONS
    WHERE "Do_not_use" = 'True'
),
patients AS (
    SELECT DISTINCT p."bcr_patient_barcode" AS patient_barcode
    FROM paad_patients p
    LEFT JOIN excluded_patients e
        ON p."bcr_patient_barcode" = e."patient_barcode"
    WHERE e."patient_barcode" IS NULL
),
mutations AS (
    SELECT
        "ParticipantBarcode" AS patient_barcode,
        MAX(CASE WHEN "Hugo_Symbol" = 'KRAS' THEN 1 ELSE 0 END) AS KRAS_mut,
        MAX(CASE WHEN "Hugo_Symbol" = 'TP53' THEN 1 ELSE 0 END) AS TP53_mut
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD'
      AND "ParticipantBarcode" IN (SELECT patient_barcode FROM patients)
      AND "Hugo_Symbol" IN ('KRAS', 'TP53')
    GROUP BY "ParticipantBarcode"
),
patient_mutations AS (
    SELECT
        p.patient_barcode,
        COALESCE(m.KRAS_mut, 0) AS KRAS_mut,
        COALESCE(m.TP53_mut, 0) AS TP53_mut
    FROM patients p
    LEFT JOIN mutations m ON p.patient_barcode = m.patient_barcode
),
counts AS (
    SELECT
        SUM(CASE WHEN KRAS_mut = 1 AND TP53_mut = 1 THEN 1 ELSE 0 END) AS both_mutated,
        SUM(CASE WHEN KRAS_mut = 1 AND TP53_mut = 0 THEN 1 ELSE 0 END) AS KRAS_only,
        SUM(CASE WHEN KRAS_mut = 0 AND TP53_mut = 1 THEN 1 ELSE 0 END) AS TP53_only,
        SUM(CASE WHEN KRAS_mut = 0 AND TP53_mut = 0 THEN 1 ELSE 0 END) AS neither_mutated,
        COUNT(*) AS total_patients
    FROM patient_mutations
),
observed AS (
    SELECT
        both_mutated,
        KRAS_only,
        TP53_only,
        neither_mutated,
        total_patients,
        both_mutated + KRAS_only AS KRAS_mutated_total,
        TP53_only + neither_mutated AS KRAS_not_mutated_total,
        both_mutated + TP53_only AS TP53_mutated_total,
        KRAS_only + neither_mutated AS TP53_not_mutated_total
    FROM counts
),
expected AS (
    SELECT
        *,
        (KRAS_mutated_total * TP53_mutated_total)::FLOAT / total_patients AS exp_both_mutated,
        (KRAS_mutated_total * TP53_not_mutated_total)::FLOAT / total_patients AS exp_KRAS_only,
        (KRAS_not_mutated_total * TP53_mutated_total)::FLOAT / total_patients AS exp_TP53_only,
        (KRAS_not_mutated_total * TP53_not_mutated_total)::FLOAT / total_patients AS exp_neither_mutated
    FROM observed
),
chi_squared AS (
    SELECT
        *,
        POWER(both_mutated - exp_both_mutated, 2) / NULLIF(exp_both_mutated, 0) AS chi_both_mutated,
        POWER(KRAS_only - exp_KRAS_only, 2) / NULLIF(exp_KRAS_only, 0) AS chi_KRAS_only,
        POWER(TP53_only - exp_TP53_only, 2) / NULLIF(exp_TP53_only, 0) AS chi_TP53_only,
        POWER(neither_mutated - exp_neither_mutated, 2) / NULLIF(exp_neither_mutated, 0) AS chi_neither_mutated,
        (
            COALESCE(POWER(both_mutated - exp_both_mutated, 2) / NULLIF(exp_both_mutated, 0), 0) +
            COALESCE(POWER(KRAS_only - exp_KRAS_only, 2) / NULLIF(exp_KRAS_only, 0), 0) +
            COALESCE(POWER(TP53_only - exp_TP53_only, 2) / NULLIF(exp_TP53_only, 0), 0) +
            COALESCE(POWER(neither_mutated - exp_neither_mutated, 2) / NULLIF(exp_neither_mutated, 0), 0)
        ) AS chi_squared_stat
    FROM expected
)
SELECT
    both_mutated,
    KRAS_only,
    TP53_only,
    neither_mutated,
    total_patients,
    ROUND(exp_both_mutated, 4) AS exp_both_mutated,
    ROUND(exp_KRAS_only, 4) AS exp_KRAS_only,
    ROUND(exp_TP53_only, 4) AS exp_TP53_only,
    ROUND(exp_neither_mutated, 4) AS exp_neither_mutated,
    ROUND(chi_both_mutated, 4) AS chi_both_mutated,
    ROUND(chi_KRAS_only, 4) AS chi_KRAS_only,
    ROUND(chi_TP53_only, 4) AS chi_TP53_only,
    ROUND(chi_neither_mutated, 4) AS chi_neither_mutated,
    ROUND(chi_squared_stat, 4) AS chi_squared_stat
FROM chi_squared;