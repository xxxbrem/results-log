WITH top_drug AS (
    SELECT `generic_name`
    FROM `bigquery-public-data.cms_medicare.part_d_prescriber_2014`
    WHERE `nppes_provider_state` = 'NY'
    GROUP BY `generic_name`
    ORDER BY SUM(`total_claim_count`) DESC
    LIMIT 1
)
SELECT `nppes_provider_state` AS State,
       SUM(`total_claim_count`) AS Total_Claim_Count,
       ROUND(SUM(`total_drug_cost`), 4) AS Total_Drug_Cost
FROM `bigquery-public-data.cms_medicare.part_d_prescriber_2014`
WHERE LOWER(`generic_name`) = LOWER((SELECT `generic_name` FROM top_drug))
GROUP BY `nppes_provider_state`
ORDER BY Total_Claim_Count DESC
LIMIT 5;