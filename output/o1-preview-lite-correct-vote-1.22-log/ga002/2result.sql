WITH customers AS (
  SELECT DISTINCT
    EXTRACT(MONTH FROM PARSE_DATE('%Y%m%d', event_date)) AS month_num,
    user_pseudo_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND event_name = 'purchase'
    AND item.item_name = 'Google Red Speckled Tee'
),
purchases AS (
  SELECT
    EXTRACT(MONTH FROM PARSE_DATE('%Y%m%d', a.event_date)) AS month_num,
    item.item_name,
    SUM(item.quantity) AS total_quantity
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS a,
    UNNEST(a.items) AS item
  JOIN customers
    ON a.user_pseudo_id = customers.user_pseudo_id
    AND EXTRACT(MONTH FROM PARSE_DATE('%Y%m%d', a.event_date)) = customers.month_num
  WHERE a._TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
    AND a.event_name = 'purchase'
    AND item.item_name != 'Google Red Speckled Tee'
  GROUP BY month_num, item.item_name
),
ranked_purchases AS (
  SELECT
    month_num,
    item_name,
    total_quantity,
    ROW_NUMBER() OVER (
      PARTITION BY month_num
      ORDER BY total_quantity DESC
    ) AS rank,
    CASE month_num
      WHEN 11 THEN 1
      WHEN 12 THEN 2
      WHEN 1 THEN 3
    END AS month_order
  FROM purchases
)
SELECT
  CASE month_num
    WHEN 11 THEN 'Nov-2020'
    WHEN 12 THEN 'Dec-2020'
    WHEN 1 THEN 'Jan-2021'
  END AS Month,
  item_name AS Product_Name,
  ROUND(total_quantity, 4) AS Quantity
FROM ranked_purchases
WHERE rank = 1
ORDER BY month_order;