WITH ProteomicsData AS (
  SELECT
    P."gene_symbol",
    TRIM(S.VALUE::VARCHAR) AS "sample_submitter_id",
    M."sample_type",
    P."protein_abundance_log2ratio"
  FROM
    CPTAC_PDC.CPTAC."QUANT_PROTEOME_CPTAC_CCRCC_DISCOVERY_STUDY_PDC_CURRENT" P
    JOIN CPTAC_PDC.PDC_METADATA."ALIQUOT_TO_CASE_MAPPING_CURRENT" M
      ON P."aliquot_id" = M."aliquot_id",
    LATERAL FLATTEN(INPUT => SPLIT(M."sample_submitter_id", ';')) S
  WHERE
    M."sample_type" IN ('Primary Tumor', 'Solid Tissue Normal')
),
RNASeqData AS (
  SELECT
    R."gene_name",
    R."sample_barcode" AS "sample_submitter_id",
    R."fpkm_unstranded",
    R."sample_type_name" AS "sample_type"
  FROM
    CPTAC_PDC.CPTAC."RNASEQ_HG38_GDC_CURRENT" R
  WHERE
    R."primary_site" = 'Kidney' AND
    R."sample_type_name" IN ('Primary Tumor', 'Solid Tissue Normal')
),
JoinedData AS (
  SELECT
    P."sample_type",
    P."gene_symbol",
    P."sample_submitter_id",
    P."protein_abundance_log2ratio",
    LN(R."fpkm_unstranded" + 1) AS "log_fpkm"
  FROM
    ProteomicsData P
    JOIN RNASeqData R
      ON P."sample_submitter_id" = R."sample_submitter_id"
      AND P."gene_symbol" = R."gene_name"
)
SELECT
  "sample_type" AS "Sample_Type",
  ROUND(AVG("gene_corr"), 4) AS "Average_Correlation"
FROM
  (
    SELECT
      "sample_type",
      "gene_symbol",
      CORR("protein_abundance_log2ratio", "log_fpkm") AS "gene_corr"
    FROM
      JoinedData
    GROUP BY
      "sample_type",
      "gene_symbol"
    HAVING
      ABS(CORR("protein_abundance_log2ratio", "log_fpkm")) <= 0.5
  ) AS "gene_correlations"
GROUP BY
  "sample_type";