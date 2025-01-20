WITH ny_top_drug AS (
  SELECT `drug_name` AS top_drug
  FROM `bigquery-public-data.cms_medicare.part_d_prescriber_2014`
  WHERE `nppes_provider_state` = 'NY'
  GROUP BY `drug_name`
  ORDER BY SUM(`total_claim_count`) DESC
  LIMIT 1
)
SELECT `nppes_provider_state` AS State,
       SUM(`total_claim_count`) AS Total_Claim_Count,
       ROUND(SUM(`total_drug_cost`), 4) AS Total_Drug_Cost
FROM `bigquery-public-data.cms_medicare.part_d_prescriber_2014`
WHERE LOWER(TRIM(`drug_name`)) = LOWER(TRIM((SELECT top_drug FROM ny_top_drug)))
GROUP BY `nppes_provider_state`
ORDER BY Total_Claim_Count DESC
LIMIT 5