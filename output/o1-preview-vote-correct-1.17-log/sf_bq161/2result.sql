SELECT
  (
    SELECT COUNT(DISTINCT kr."ParticipantBarcode")
    FROM
      (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
      ) kr
    INNER JOIN
      (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
      ) tp53
      ON kr."ParticipantBarcode" = tp53."ParticipantBarcode"
  ) -
  (
    SELECT COUNT(DISTINCT clin."bcr_patient_barcode")
    FROM
      (
        SELECT DISTINCT "bcr_patient_barcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_CLINICAL_PANCAN_PATIENT_WITH_FOLLOWUP
        WHERE "disease_code" = 'PAAD'
      ) clin
    LEFT JOIN
      (
        SELECT DISTINCT "ParticipantBarcode"
        FROM PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
        WHERE "Study" = 'PAAD' AND "Hugo_Symbol" IN ('KRAS', 'TP53') AND "FILTER" = 'PASS'
      ) mut
      ON clin."bcr_patient_barcode" = mut."ParticipantBarcode"
    WHERE mut."ParticipantBarcode" IS NULL
  ) AS "Net_Difference";