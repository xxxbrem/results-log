WITH inp AS (
  SELECT 
    "provider_id", 
    "provider_name", 
    SUM("total_discharges") AS total_inpatient_services, 
    SUM("total_discharges" * "average_total_payments") AS total_inpatient_payments
  FROM CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
  GROUP BY "provider_id", "provider_name"
),
outp AS (
  SELECT 
    "provider_id", 
    "provider_name", 
    SUM("outpatient_services") AS total_outpatient_services, 
    SUM("outpatient_services" * "average_total_payments") AS total_outpatient_payments
  FROM CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
  GROUP BY "provider_id", "provider_name"
),
combined AS (
  SELECT
    COALESCE(inp."provider_id", outp."provider_id") AS "provider_id",
    COALESCE(inp."provider_name", outp."provider_name") AS "provider_name",
    NVL(inp.total_inpatient_services, 0) + NVL(outp.total_outpatient_services, 0) AS total_services,
    NVL(inp.total_inpatient_payments, 0) + NVL(outp.total_outpatient_payments, 0) AS total_payments,
    (NVL(inp.total_inpatient_payments, 0) + NVL(outp.total_outpatient_payments, 0)) /
    NULLIF(NVL(inp.total_inpatient_services, 0) + NVL(outp.total_outpatient_services, 0), 0) AS combined_average_cost_per_service
  FROM inp
  FULL OUTER JOIN outp
  ON inp."provider_id" = outp."provider_id"
)
SELECT "provider_id", "provider_name", ROUND(combined_average_cost_per_service, 4) AS combined_average_cost_per_service
FROM combined
ORDER BY combined_average_cost_per_service DESC NULLS LAST
LIMIT 1;