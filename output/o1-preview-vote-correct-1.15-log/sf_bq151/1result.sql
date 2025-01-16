WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS patient_barcode
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
kras_mutations AS (
    SELECT DISTINCT "ParticipantBarcode" AS patient_barcode
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
),
tp53_mutations AS (
    SELECT DISTINCT "ParticipantBarcode" AS patient_barcode
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
),
mutation_status AS (
    SELECT
        p.patient_barcode,
        CASE WHEN k.patient_barcode IS NOT NULL THEN 1 ELSE 0 END AS kras_mutated,
        CASE WHEN t.patient_barcode IS NOT NULL THEN 1 ELSE 0 END AS tp53_mutated
    FROM paad_patients p
    LEFT JOIN kras_mutations k ON p.patient_barcode = k.patient_barcode
    LEFT JOIN tp53_mutations t ON p.patient_barcode = t.patient_barcode
),
contingency_table AS (
    SELECT
        SUM(CASE WHEN kras_mutated = 1 AND tp53_mutated = 1 THEN 1 ELSE 0 END) AS both_mutated,
        SUM(CASE WHEN kras_mutated = 1 AND tp53_mutated = 0 THEN 1 ELSE 0 END) AS kras_only,
        SUM(CASE WHEN kras_mutated = 0 AND tp53_mutated = 1 THEN 1 ELSE 0 END) AS tp53_only,
        SUM(CASE WHEN kras_mutated = 0 AND tp53_mutated = 0 THEN 1 ELSE 0 END) AS neither_mutated
    FROM mutation_status
),
expected_values AS (
    SELECT
        *,
        (both_mutated + kras_only + tp53_only + neither_mutated) AS total,
        (both_mutated + kras_only) AS kras_total,
        (both_mutated + tp53_only) AS tp53_total,
        ((both_mutated + kras_only) * (both_mutated + tp53_only)) / NULLIF((both_mutated + kras_only + tp53_only + neither_mutated), 0) AS expected_both_mutated,
        ((both_mutated + kras_only) * (tp53_only + neither_mutated)) / NULLIF((both_mutated + kras_only + tp53_only + neither_mutated), 0) AS expected_kras_only,
        ((tp53_only + neither_mutated) * (both_mutated + tp53_only)) / NULLIF((both_mutated + kras_only + tp53_only + neither_mutated), 0) AS expected_tp53_only,
        ((tp53_only + neither_mutated) * (kras_only + neither_mutated)) / NULLIF((both_mutated + kras_only + tp53_only + neither_mutated), 0) AS expected_neither_mutated
    FROM contingency_table
),
chi_square_calc AS (
    SELECT
        ROUND(
            (POWER(both_mutated - expected_both_mutated, 2) / NULLIF(expected_both_mutated, 0) +
            POWER(kras_only - expected_kras_only, 2) / NULLIF(expected_kras_only, 0) +
            POWER(tp53_only - expected_tp53_only, 2) / NULLIF(expected_tp53_only, 0) +
            POWER(neither_mutated - expected_neither_mutated, 2) / NULLIF(expected_neither_mutated, 0))
        , 4) AS chi_square_statistic
    FROM expected_values
)
SELECT chi_square_statistic
FROM chi_square_calc;