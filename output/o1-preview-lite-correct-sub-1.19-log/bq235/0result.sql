WITH inpatient_payments AS (
  SELECT
    provider_id,
    provider_name,
    SUM(average_total_payments * total_discharges) AS total_inpatient_payments
  FROM
    `bigquery-public-data.cms_medicare.inpatient_charges_2014`
  GROUP BY
    provider_id,
    provider_name
),
outpatient_payments AS (
  SELECT
    provider_id,
    provider_name,
    SUM(average_total_payments * outpatient_services) AS total_outpatient_payments
  FROM
    `bigquery-public-data.cms_medicare.outpatient_charges_2014`
  GROUP BY
    provider_id,
    provider_name
),
combined_payments AS (
  SELECT
    COALESCE(ip.provider_id, op.provider_id) AS provider_id,
    COALESCE(ip.provider_name, op.provider_name) AS provider_name,
    IFNULL(ip.total_inpatient_payments, 0) + IFNULL(op.total_outpatient_payments, 0) AS combined_total_payments
  FROM
    inpatient_payments ip
  FULL OUTER JOIN
    outpatient_payments op
  ON
    ip.provider_id = op.provider_id
)
SELECT
  provider_id,
  provider_name,
  ROUND(combined_total_payments, 4) AS combined_average_total_payments
FROM
  combined_payments
ORDER BY
  combined_average_total_payments DESC
LIMIT 1;