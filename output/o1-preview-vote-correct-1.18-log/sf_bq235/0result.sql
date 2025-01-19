SELECT
  COALESCE(ip."provider_id", op."provider_id") AS "provider_id",
  COALESCE(ip."provider_name", op."provider_name") AS "provider_name",
  ROUND(COALESCE(ip."avg_inpatient_payment", 0) + COALESCE(op."avg_outpatient_payment", 0), 4) AS "combined_average_cost"
FROM
  (SELECT "provider_id", "provider_name", AVG("average_total_payments") AS "avg_inpatient_payment"
   FROM CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
   GROUP BY "provider_id", "provider_name") ip
FULL OUTER JOIN
  (SELECT "provider_id", "provider_name", AVG("average_total_payments") AS "avg_outpatient_payment"
   FROM CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
   GROUP BY "provider_id", "provider_name") op
ON ip."provider_id" = op."provider_id"
ORDER BY "combined_average_cost" DESC NULLS LAST
LIMIT 1