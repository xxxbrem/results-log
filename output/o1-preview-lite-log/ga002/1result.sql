WITH red_tee_purchasers AS (
  SELECT
    DISTINCT user_pseudo_id,
    SUBSTR(event_date, 1, 6) AS month
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item
  WHERE
    event_name = 'purchase'
    AND item.item_name = 'Google Red Speckled Tee'
    AND event_date BETWEEN '20201101' AND '20210131'
),
other_purchases AS (
  SELECT
    SUBSTR(events.event_date, 1, 6) AS month,
    item.item_name AS product_name,
    SUM(item.quantity) AS total_quantity
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS events
  INNER JOIN
    red_tee_purchasers rp
  ON
    events.user_pseudo_id = rp.user_pseudo_id
    AND SUBSTR(events.event_date, 1, 6) = rp.month
  CROSS JOIN
    UNNEST(events.items) AS item
  WHERE
    events.event_name = 'purchase'
    AND events.event_date BETWEEN '20201101' AND '20210131'
    AND item.item_name != 'Google Red Speckled Tee'
  GROUP BY
    month,
    product_name
)
SELECT
  CASE month
    WHEN '202011' THEN 'Nov-2020'
    WHEN '202012' THEN 'Dec-2020'
    WHEN '202101' THEN 'Jan-2021'
  END AS Month,
  product_name AS Product_Name,
  total_quantity AS Quantity
FROM (
  SELECT
    month,
    product_name,
    total_quantity,
    ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_quantity DESC) AS rn
  FROM
    other_purchases
)
WHERE
  rn = 1
ORDER BY
  (CASE Month
    WHEN 'Nov-2020' THEN 1
    WHEN 'Dec-2020' THEN 2
    WHEN 'Jan-2021' THEN 3
  END)