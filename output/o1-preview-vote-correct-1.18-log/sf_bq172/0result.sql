SELECT t1."nppes_provider_state" AS "State",
       SUM(t1."total_claim_count") AS "Total_Claim_Count",
       SUM(t1."total_drug_cost") AS "Total_Drug_Cost"
FROM CMS_DATA.CMS_MEDICARE.PART_D_PRESCRIBER_2014 t1
JOIN (
    SELECT "drug_name"
    FROM CMS_DATA.CMS_MEDICARE.PART_D_PRESCRIBER_2014
    WHERE "nppes_provider_state" = 'NY'
    GROUP BY "drug_name"
    ORDER BY SUM("total_claim_count") DESC NULLS LAST
    LIMIT 1
) t2 ON t1."drug_name" = t2."drug_name"
GROUP BY t1."nppes_provider_state"
ORDER BY "Total_Claim_Count" DESC NULLS LAST
LIMIT 5;