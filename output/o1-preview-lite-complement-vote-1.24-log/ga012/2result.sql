SELECT DISTINCT
  t.ecommerce.transaction_id,
  t.ecommerce.total_item_quantity,
  t.ecommerce.purchase_revenue_in_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130` AS t
JOIN UNNEST(t.items) AS item
WHERE t.event_date = '20201130'
  AND t.event_name = 'purchase'
  AND item.item_category = (
    SELECT item_category
    FROM (
      SELECT
        item.item_category,
        AVG(t.ecommerce.tax_value_in_usd / t.ecommerce.purchase_revenue_in_usd) AS avg_tax_rate
      FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201130` AS t
      JOIN UNNEST(t.items) AS item
      WHERE t.event_date = '20201130' AND t.event_name = 'purchase'
      GROUP BY item.item_category
      ORDER BY avg_tax_rate DESC
      LIMIT 1
    ) AS sub_query
  );