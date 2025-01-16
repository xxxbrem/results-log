WITH top_drug AS (
    SELECT "drug_name"
    FROM CMS_DATA.CMS_MEDICARE.PART_D_PRESCRIBER_2014
    WHERE "nppes_provider_state" = 'NY'
    GROUP BY "drug_name"
    ORDER BY SUM("total_claim_count") DESC NULLS LAST
    LIMIT 1
)
SELECT "nppes_provider_state" AS "state",
       SUM("total_claim_count") AS "total_claim_count",
       ROUND(SUM("total_drug_cost"), 4) AS "total_drug_cost"
FROM CMS_DATA.CMS_MEDICARE.PART_D_PRESCRIBER_2014
WHERE "drug_name" = (SELECT "drug_name" FROM top_drug)
GROUP BY "nppes_provider_state"
ORDER BY "total_claim_count" DESC NULLS LAST
LIMIT 5;