WITH highest_tax_category AS (
  SELECT items.item_category
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130`,
       UNNEST(items) AS items
  WHERE event_date = '20201130'
    AND items.item_category IS NOT NULL
    AND items.item_category != ''
    AND ecommerce.tax_value_in_usd IS NOT NULL
    AND ecommerce.purchase_revenue_in_usd IS NOT NULL
    AND ecommerce.purchase_revenue_in_usd != 0
  GROUP BY items.item_category
  ORDER BY SUM(ecommerce.tax_value_in_usd) / SUM(ecommerce.purchase_revenue_in_usd) DESC
  LIMIT 1
)
SELECT ecommerce.transaction_id,
       ecommerce.total_item_quantity,
       ecommerce.purchase_revenue_in_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130`,
     UNNEST(items) AS items,
     highest_tax_category
WHERE event_date = '20201130'
  AND items.item_category = highest_tax_category.item_category
  AND ecommerce.transaction_id IS NOT NULL
  AND ecommerce.total_item_quantity IS NOT NULL
  AND ecommerce.purchase_revenue_in_usd IS NOT NULL;