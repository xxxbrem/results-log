WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS patient_id
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
kr_mutation_patients AS (
    SELECT DISTINCT "ParticipantBarcode" AS patient_id
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
),
tp53_mutation_patients AS (
    SELECT DISTINCT "ParticipantBarcode" AS patient_id
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
),
both_mutation_patients AS (
    SELECT patient_id
    FROM kr_mutation_patients
    INNER JOIN tp53_mutation_patients USING (patient_id)
),
neither_mutation_patients AS (
    SELECT p.patient_id
    FROM paad_patients p
    LEFT JOIN kr_mutation_patients k ON p.patient_id = k.patient_id
    LEFT JOIN tp53_mutation_patients t ON p.patient_id = t.patient_id
    WHERE k.patient_id IS NULL AND t.patient_id IS NULL
)
SELECT
    ((SELECT COUNT(*) FROM both_mutation_patients) - (SELECT COUNT(*) FROM neither_mutation_patients)) AS net_difference;