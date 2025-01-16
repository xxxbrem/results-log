WITH inpatient_avg AS (
    SELECT
        "provider_id",
        MAX("provider_name") AS "provider_name",
        AVG("average_total_payments") AS "avg_inpatient_payment"
    FROM
        CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
    GROUP BY
        "provider_id"
),
outpatient_avg AS (
    SELECT
        "provider_id",
        MAX("provider_name") AS "provider_name",
        AVG("average_total_payments") AS "avg_outpatient_payment"
    FROM
        CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
    GROUP BY
        "provider_id"
)
SELECT
    COALESCE(i."provider_id", o."provider_id") AS "provider_id",
    COALESCE(i."provider_name", o."provider_name") AS "provider_name",
    ROUND(NVL(i."avg_inpatient_payment", 0) + NVL(o."avg_outpatient_payment", 0), 4) AS "combined_average_cost"
FROM
    inpatient_avg i
    FULL OUTER JOIN outpatient_avg o ON i."provider_id" = o."provider_id"
ORDER BY
    "combined_average_cost" DESC NULLS LAST
LIMIT 1;