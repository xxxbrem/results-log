WITH clinical_paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),
kras_patients AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS' AND "Hugo_Symbol" = 'KRAS'
),
tp53_patients AS (
    SELECT DISTINCT "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Study" = 'PAAD' AND "FILTER" = 'PASS' AND "Hugo_Symbol" = 'TP53'
),
both_kras_tp53_patients AS (
    SELECT "ParticipantBarcode"
    FROM kras_patients
    INTERSECT
    SELECT "ParticipantBarcode"
    FROM tp53_patients
),
either_kras_or_tp53_patients AS (
    SELECT "ParticipantBarcode" FROM kras_patients
    UNION
    SELECT "ParticipantBarcode" FROM tp53_patients
),
neither_kras_nor_tp53_patients AS (
    SELECT "ParticipantBarcode"
    FROM clinical_paad_patients
    WHERE "ParticipantBarcode" NOT IN (
        SELECT "ParticipantBarcode" FROM either_kras_or_tp53_patients
    )
)
SELECT
    COUNT(*) AS "Number_with_both_KRAS_and_TP53_mutations",
    (SELECT COUNT(*) FROM neither_kras_nor_tp53_patients) AS "Number_without_mutations_in_either_gene",
    COUNT(*) - (SELECT COUNT(*) FROM neither_kras_nor_tp53_patients) AS "Net_Difference"
FROM both_kras_tp53_patients;