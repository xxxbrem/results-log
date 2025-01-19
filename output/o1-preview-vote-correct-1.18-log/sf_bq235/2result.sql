WITH InpatientAvg AS (
    SELECT
        "provider_id",
        "provider_name",
        AVG("average_total_payments") AS avg_inpatient_payment
    FROM
        "CMS_DATA"."CMS_MEDICARE"."INPATIENT_CHARGES_2014"
    GROUP BY
        "provider_id",
        "provider_name"
),
OutpatientAvg AS (
    SELECT
        "provider_id",
        "provider_name",
        AVG("average_total_payments") AS avg_outpatient_payment
    FROM
        "CMS_DATA"."CMS_MEDICARE"."OUTPATIENT_CHARGES_2014"
    GROUP BY
        "provider_id",
        "provider_name"
)
SELECT
    IP."provider_id",
    IP."provider_name",
    ROUND(IP.avg_inpatient_payment + OP.avg_outpatient_payment, 4) AS combined_average_cost
FROM
    InpatientAvg IP
JOIN
    OutpatientAvg OP
ON
    IP."provider_id" = OP."provider_id"
ORDER BY
    combined_average_cost DESC NULLS LAST
LIMIT 1;