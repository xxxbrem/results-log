SELECT
  `provider_id`,
  `provider_name`,
  ROUND(SUM(`average_total_payments`), 4) AS `combined_average_total_payments`
FROM (
  SELECT
    `provider_id`,
    `provider_name`,
    `average_total_payments`
  FROM
    `bigquery-public-data.cms_medicare.inpatient_charges_2014`
  UNION ALL
  SELECT
    `provider_id`,
    `provider_name`,
    `average_total_payments`
  FROM
    `bigquery-public-data.cms_medicare.outpatient_charges_2014`
) AS `combined_payments`
WHERE
  `average_total_payments` IS NOT NULL
GROUP BY
  `provider_id`,
  `provider_name`
ORDER BY
  `combined_average_total_payments` DESC,
  `provider_id`
LIMIT
  1;