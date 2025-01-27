WITH highest_tax_category AS (
  SELECT
    item.item_category
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130`,
    UNNEST(items) AS item
  WHERE
    event_name = 'purchase' AND
    ecommerce.tax_value_in_usd IS NOT NULL AND
    ecommerce.purchase_revenue_in_usd IS NOT NULL AND
    item.item_category IS NOT NULL
  GROUP BY
    item.item_category
  ORDER BY
    SAFE_DIVIDE(SUM(ecommerce.tax_value_in_usd), SUM(ecommerce.purchase_revenue_in_usd)) DESC
  LIMIT
    1
)
SELECT
  ecommerce.transaction_id,
  ecommerce.total_item_quantity,
  ecommerce.purchase_revenue_in_usd
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130`,
  UNNEST(items) AS item,
  highest_tax_category
WHERE
  event_name = 'purchase' AND
  item.item_category = highest_tax_category.item_category AND
  ecommerce.transaction_id IS NOT NULL AND
  ecommerce.total_item_quantity IS NOT NULL AND
  ecommerce.purchase_revenue_in_usd IS NOT NULL;