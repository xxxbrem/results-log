WITH inpatient AS (
    SELECT
        "provider_id",
        MAX("provider_name") AS "provider_name",
        SUM("average_total_payments" * "total_discharges") AS "total_inpatient_payments",
        SUM("total_discharges") AS "total_inpatient_services"
    FROM
        CMS_DATA.CMS_MEDICARE.INPATIENT_CHARGES_2014
    GROUP BY
        "provider_id"
),
outpatient AS (
    SELECT
        "provider_id",
        MAX("provider_name") AS "provider_name",
        SUM("average_total_payments" * "outpatient_services") AS "total_outpatient_payments",
        SUM("outpatient_services") AS "total_outpatient_services"
    FROM
        CMS_DATA.CMS_MEDICARE.OUTPATIENT_CHARGES_2014
    GROUP BY
        "provider_id"
)
SELECT
    COALESCE(i."provider_id", o."provider_id") AS "provider_id",
    COALESCE(i."provider_name", o."provider_name") AS "provider_name",
    ROUND(
        (
            COALESCE(i."total_inpatient_payments", 0) + COALESCE(o."total_outpatient_payments", 0)
        ) / NULLIF(
            COALESCE(i."total_inpatient_services", 0) + COALESCE(o."total_outpatient_services", 0), 0
        ),
        4
    ) AS "combined_average_cost_per_service"
FROM
    inpatient i
FULL OUTER JOIN
    outpatient o
ON
    i."provider_id" = o."provider_id"
ORDER BY
    "combined_average_cost_per_service" DESC NULLS LAST
LIMIT 1;