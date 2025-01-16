WITH paad_patients AS (
    SELECT DISTINCT "bcr_patient_barcode" AS "ParticipantBarcode"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
    WHERE "acronym" = 'PAAD'
),

kras_mutations AS (
    SELECT DISTINCT "ParticipantBarcode", 1 AS "KRAS_Mutated"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Hugo_Symbol" = 'KRAS' AND 
          "FILTER" = 'PASS' AND
          "Study" = 'PAAD'
),

tp53_mutations AS (
    SELECT DISTINCT "ParticipantBarcode", 1 AS "TP53_Mutated"
    FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE "Hugo_Symbol" = 'TP53' AND 
          "FILTER" = 'PASS' AND
          "Study" = 'PAAD'
),

patient_mutations AS (
    SELECT p."ParticipantBarcode",
           COALESCE(k."KRAS_Mutated", 0) AS "KRAS_Mutated",
           COALESCE(t."TP53_Mutated", 0) AS "TP53_Mutated"
    FROM paad_patients p
    LEFT JOIN kras_mutations k ON p."ParticipantBarcode" = k."ParticipantBarcode"
    LEFT JOIN tp53_mutations t ON p."ParticipantBarcode" = t."ParticipantBarcode"
)

SELECT
    ROUND(
    (
      COUNT(*) * POWER(
        (SUM(CASE WHEN "KRAS_Mutated" = 1 AND "TP53_Mutated" = 1 THEN 1 ELSE 0 END) * 
         SUM(CASE WHEN "KRAS_Mutated" = 0 AND "TP53_Mutated" = 0 THEN 1 ELSE 0 END) - 
         SUM(CASE WHEN "KRAS_Mutated" = 1 AND "TP53_Mutated" = 0 THEN 1 ELSE 0 END) * 
         SUM(CASE WHEN "KRAS_Mutated" = 0 AND "TP53_Mutated" = 1 THEN 1 ELSE 0 END)
      ), 2
      )
    ) /
    (
      SUM(CASE WHEN "KRAS_Mutated" = 1 THEN 1 ELSE 0 END) * 
      SUM(CASE WHEN "KRAS_Mutated" = 0 THEN 1 ELSE 0 END) *
      SUM(CASE WHEN "TP53_Mutated" = 1 THEN 1 ELSE 0 END) *
      SUM(CASE WHEN "TP53_Mutated" = 0 THEN 1 ELSE 0 END)
    ), 4
    ) AS "chi_value"
FROM patient_mutations;