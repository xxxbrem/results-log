SELECT
  ROUND(
    (
      1 - (
        SELECT COUNT(DISTINCT person_id)
        FROM `bigquery-public-data.cms_synthetic_patient_data_omop.drug_exposure`
        WHERE drug_concept_id IN (
          SELECT descendant_concept_id
          FROM `bigquery-public-data.cms_synthetic_patient_data_omop.concept_ancestor`
          WHERE ancestor_concept_id = 1331235
        )
      ) / (
        SELECT COUNT(DISTINCT person_id)
        FROM `bigquery-public-data.cms_synthetic_patient_data_omop.person`
      )
    ) * 100, 4) AS percentage_not_using_quinapril;