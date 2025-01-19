SELECT
    COALESCE(inpatient."provider_id", outpatient."provider_id") AS "provider_id",
    COALESCE(inpatient."provider_name", outpatient."provider_name") AS "provider_name",
    ROUND(COALESCE(total_inpatient_payments, 0) + COALESCE(total_outpatient_payments, 0), 4) AS combined_total_payments
FROM
    (
        SELECT
            "provider_id",
            "provider_name",
            SUM("total_discharges" * "average_total_payments") AS total_inpatient_payments
        FROM
            CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
        GROUP BY
            "provider_id", "provider_name"
    ) AS inpatient
FULL OUTER JOIN
    (
        SELECT
            "provider_id",
            "provider_name",
            SUM("outpatient_services" * "average_total_payments") AS total_outpatient_payments
        FROM
            CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
        GROUP BY
            "provider_id", "provider_name"
    ) AS outpatient
ON
    inpatient."provider_id" = outpatient."provider_id"
ORDER BY
    combined_total_payments DESC NULLS LAST
LIMIT 1;