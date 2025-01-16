WITH
  paad_patients AS (
    SELECT DISTINCT
      "ParticipantBarcode"
    FROM
      PANCANCER_ATLAS_2.PANCANCER_ATLAS.BARCODEMAP
    WHERE
      "Study" = 'PAAD'
  ),
  patients_with_kras AS (
    SELECT DISTINCT
      "ParticipantBarcode"
    FROM
      PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE
      "Study" = 'PAAD' AND "Hugo_Symbol" = 'KRAS' AND "FILTER" = 'PASS'
  ),
  patients_with_tp53 AS (
    SELECT DISTINCT
      "ParticipantBarcode"
    FROM
      PANCANCER_ATLAS_2.PANCANCER_ATLAS.FILTERED_MC3_MAF_V5_ONE_PER_TUMOR_SAMPLE
    WHERE
      "Study" = 'PAAD' AND "Hugo_Symbol" = 'TP53' AND "FILTER" = 'PASS'
  ),
  patients_with_both AS (
    SELECT
      p."ParticipantBarcode"
    FROM
      patients_with_kras p
      INNER JOIN patients_with_tp53 t ON p."ParticipantBarcode" = t."ParticipantBarcode"
  ),
  patients_with_either AS (
    SELECT DISTINCT
      "ParticipantBarcode"
    FROM
      patients_with_kras
    UNION
    SELECT DISTINCT
      "ParticipantBarcode"
    FROM
      patients_with_tp53
  ),
  patients_with_neither AS (
    SELECT
      p."ParticipantBarcode"
    FROM
      paad_patients p
      LEFT JOIN patients_with_either e ON p."ParticipantBarcode" = e."ParticipantBarcode"
    WHERE
      e."ParticipantBarcode" IS NULL
  ),
  patients_with_both_count AS (
    SELECT
      COUNT(DISTINCT "ParticipantBarcode") AS num
    FROM
      patients_with_both
  ),
  patients_with_neither_count AS (
    SELECT
      COUNT(DISTINCT "ParticipantBarcode") AS num
    FROM
      patients_with_neither
  )
SELECT
  patients_with_both_count.num - patients_with_neither_count.num AS net_difference
FROM
  patients_with_both_count,
  patients_with_neither_count;