SELECT
  COALESCE(ip."provider_id", op."provider_id") AS "provider_id",
  COALESCE(ip."provider_name", op."provider_name") AS "provider_name",
  ROUND(
    COALESCE(ip."total_inpatient_payments", 0) + COALESCE(op."total_outpatient_payments", 0),
    4
  ) AS "total_combined_payments"
FROM
  (
    SELECT
      "provider_id",
      "provider_name",
      SUM("average_total_payments" * "total_discharges") AS "total_inpatient_payments"
    FROM CMS_DATA.CMS_MEDICARE."INPATIENT_CHARGES_2014"
    GROUP BY "provider_id", "provider_name"
  ) ip
FULL OUTER JOIN
  (
    SELECT
      "provider_id",
      "provider_name",
      SUM("average_total_payments" * "outpatient_services") AS "total_outpatient_payments"
    FROM CMS_DATA.CMS_MEDICARE."OUTPATIENT_CHARGES_2014"
    GROUP BY "provider_id", "provider_name"
  ) op
ON ip."provider_id" = op."provider_id" AND ip."provider_name" = op."provider_name"
ORDER BY "total_combined_payments" DESC NULLS LAST
LIMIT 1;