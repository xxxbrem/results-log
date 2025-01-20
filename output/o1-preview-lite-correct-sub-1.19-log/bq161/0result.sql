SELECT
  (
    SELECT COUNT(*)
    FROM (
      SELECT m.ParticipantBarcode
      FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample` m
      JOIN `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup` c
        ON m.ParticipantBarcode = c.bcr_patient_barcode
      WHERE c.acronym = 'PAAD' AND m.Hugo_Symbol IN ('KRAS', 'TP53')
      GROUP BY m.ParticipantBarcode
      HAVING COUNT(DISTINCT m.Hugo_Symbol) = 2
    )
  ) -
  (
    SELECT COUNT(*)
    FROM (
      SELECT DISTINCT c.bcr_patient_barcode
      FROM `isb-cgc-bq.pancancer_atlas.Filtered_clinical_PANCAN_patient_with_followup` c
      WHERE c.acronym = 'PAAD'
        AND c.bcr_patient_barcode NOT IN (
          SELECT DISTINCT m.ParticipantBarcode
          FROM `isb-cgc-bq.pancancer_atlas.Filtered_MC3_MAF_V5_one_per_tumor_sample` m
          WHERE m.Hugo_Symbol IN ('KRAS', 'TP53')
        )
    )
  ) AS NetDifference;