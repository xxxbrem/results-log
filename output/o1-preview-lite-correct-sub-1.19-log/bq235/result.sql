WITH inpatient_payments AS (
  SELECT
    `provider_id`,
    ANY_VALUE(`provider_name`) AS `provider_name`,
    SUM(`total_discharges` * `average_total_payments`) AS total_inpatient_payments
  FROM
    `bigquery-public-data.cms_medicare.inpatient_charges_2014`
  GROUP BY
    `provider_id`
),
outpatient_payments AS (
  SELECT
    `provider_id`,
    ANY_VALUE(`provider_name`) AS `provider_name`,
    SUM(`outpatient_services` * `average_total_payments`) AS total_outpatient_payments
  FROM
    `bigquery-public-data.cms_medicare.outpatient_charges_2014`
  GROUP BY
    `provider_id`
)
SELECT
  COALESCE(ip.`provider_id`, op.`provider_id`) AS `provider_id`,
  COALESCE(ip.`provider_name`, op.`provider_name`) AS `provider_name`,
  ROUND((COALESCE(ip.total_inpatient_payments, 0) + COALESCE(op.total_outpatient_payments, 0)), 4) AS `combined_average_total_payments`
FROM
  inpatient_payments ip
FULL OUTER JOIN
  outpatient_payments op
ON
  ip.`provider_id` = op.`provider_id`
ORDER BY
  `combined_average_total_payments` DESC
LIMIT
  1;