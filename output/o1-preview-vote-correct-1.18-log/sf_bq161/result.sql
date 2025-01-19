WITH
    paad_patients AS (
        SELECT DISTINCT "bcr_patient_barcode" AS "PatientBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
        WHERE "acronym" = 'PAAD'
    ),
    kras_patients AS (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS' AND "Study" = 'PAAD'
    ),
    tp53_patients AS (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS' AND "Study" = 'PAAD'
    ),
    both_mutated_patients AS (
        SELECT "ParticipantBarcode"
        FROM kras_patients
        INTERSECT
        SELECT "ParticipantBarcode"
        FROM tp53_patients
    ),
    either_mutated_patients AS (
        SELECT "ParticipantBarcode" FROM kras_patients
        UNION
        SELECT "ParticipantBarcode" FROM tp53_patients
    ),
    no_mutation_patients AS (
        SELECT "PatientBarcode"
        FROM paad_patients
        WHERE "PatientBarcode" NOT IN (
            SELECT "ParticipantBarcode" FROM either_mutated_patients
        )
    )
SELECT
    (SELECT COUNT(*) FROM both_mutated_patients) -
    (SELECT COUNT(*) FROM no_mutation_patients) AS net_difference;