SELECT
  item.item_name AS Product_Name,
  SUM(item.quantity) AS Total_Quantity
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_202012*`,
  UNNEST(items) AS item
WHERE
  user_pseudo_id IN (
    SELECT DISTINCT
      user_pseudo_id
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_202012*`,
      UNNEST(items) AS item_sub
    WHERE
      LOWER(item_sub.item_name) = LOWER('Google Navy Speckled Tee')
  )
  AND LOWER(item.item_name) != LOWER('Google Navy Speckled Tee')
GROUP BY
  item.item_name
ORDER BY
  Total_Quantity DESC
LIMIT 1;