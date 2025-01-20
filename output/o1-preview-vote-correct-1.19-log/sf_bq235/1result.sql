WITH inpatient_totals AS (
  SELECT
    "provider_id",
    "provider_name",
    SUM("total_discharges" * "average_total_payments") AS total_inpatient_payments,
    SUM("total_discharges") AS total_inpatient_services
  FROM "CMS_DATA"."CMS_MEDICARE"."INPATIENT_CHARGES_2014"
  GROUP BY "provider_id", "provider_name"
),
outpatient_totals AS (
  SELECT
    "provider_id",
    "provider_name",
    SUM("outpatient_services" * "average_total_payments") AS total_outpatient_payments,
    SUM("outpatient_services") AS total_outpatient_services
  FROM "CMS_DATA"."CMS_MEDICARE"."OUTPATIENT_CHARGES_2014"
  GROUP BY "provider_id", "provider_name"
),
combined_totals AS (
  SELECT
    COALESCE(i."provider_id", o."provider_id") AS "provider_id",
    COALESCE(i."provider_name", o."provider_name") AS "provider_name",
    COALESCE(i.total_inpatient_payments, 0) + COALESCE(o.total_outpatient_payments, 0) AS total_payments,
    COALESCE(i.total_inpatient_services, 0) + COALESCE(o.total_outpatient_services, 0) AS total_services
  FROM inpatient_totals i
  FULL OUTER JOIN outpatient_totals o
    ON i."provider_id" = o."provider_id"
)
SELECT
  "provider_id",
  "provider_name",
  ROUND(total_payments / total_services, 4) AS "combined_average_cost_per_service"
FROM combined_totals
WHERE total_services > 0
ORDER BY "combined_average_cost_per_service" DESC NULLS LAST
LIMIT 1;