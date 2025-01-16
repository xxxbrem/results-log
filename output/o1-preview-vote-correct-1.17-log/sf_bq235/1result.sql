SELECT t1."provider_id", t1."provider_name", 
       ROUND(t1."avg_inpatient_payments" + t2."avg_outpatient_payments", 4) AS "combined_average_cost"
FROM
  (SELECT "provider_id", "provider_name", AVG("average_total_payments") AS "avg_inpatient_payments"
   FROM CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
   GROUP BY "provider_id", "provider_name") t1
JOIN
  (SELECT "provider_id", AVG("average_total_payments") AS "avg_outpatient_payments"
   FROM CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
   GROUP BY "provider_id") t2
ON t1."provider_id" = t2."provider_id"
ORDER BY "combined_average_cost" DESC NULLS LAST
LIMIT 1;