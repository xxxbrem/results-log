WITH users_who_bought_tee AS (
  SELECT DISTINCT user_pseudo_id, 
    SUBSTR(_TABLE_SUFFIX, 1, 6) AS month
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`, UNNEST(items) AS item
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND LOWER(item.item_name) = 'google red speckled tee'
    AND user_pseudo_id IS NOT NULL
),
purchases_by_those_users AS (
  SELECT user_pseudo_id,
    SUBSTR(_TABLE_SUFFIX, 1, 6) AS month,
    item.item_name,
    IFNULL(item.quantity, 0) AS quantity
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`, UNNEST(items) AS item
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND user_pseudo_id IS NOT NULL
),
filtered_purchases AS (
  SELECT p.month, p.item_name, SUM(p.quantity) AS total_quantity
  FROM purchases_by_those_users p
  JOIN users_who_bought_tee u ON p.user_pseudo_id = u.user_pseudo_id AND p.month = u.month
  WHERE LOWER(p.item_name) != 'google red speckled tee'
    AND p.item_name IS NOT NULL
  GROUP BY p.month, p.item_name
),
ranked_products AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_quantity DESC, item_name) AS rn
  FROM filtered_purchases
)
SELECT 
  month,
  item_name AS `Product Name`,
  total_quantity AS `Quantity Purchased`
FROM ranked_products
WHERE rn = 1
ORDER BY month;