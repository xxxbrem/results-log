WITH december_events AS (
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201201`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201202`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201203`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201204`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201205`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201206`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201207`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201208`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201209`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201210`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201211`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201212`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201213`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201214`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201215`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201216`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201217`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201218`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201219`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201220`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201221`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201222`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201223`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201224`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201225`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201226`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201227`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201228`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201229`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201230`
  UNION ALL
  SELECT * FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
),
transactions_with_tee AS (
  SELECT DISTINCT ecommerce.transaction_id
  FROM december_events AS e,
  UNNEST(e.items) AS item
  WHERE item.item_name = 'Google Navy Speckled Tee'
)
SELECT
  item.item_name AS Product_Name,
  SUM(item.quantity) AS Total_Quantity
FROM december_events AS e,
UNNEST(e.items) AS item
WHERE
  e.ecommerce.transaction_id IN (SELECT transaction_id FROM transactions_with_tee)
  AND item.item_name != 'Google Navy Speckled Tee'
GROUP BY
  item.item_name
ORDER BY
  Total_Quantity DESC
LIMIT 1