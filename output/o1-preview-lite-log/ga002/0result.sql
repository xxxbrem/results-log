SELECT
  FORMAT_DATE('%b-%Y', Month) AS Month,
  Product_Name,
  Quantity
FROM (
  SELECT
    Month,
    Product_Name,
    Quantity,
    ROW_NUMBER() OVER (PARTITION BY Month ORDER BY Quantity DESC) AS rn
  FROM (
    SELECT
      DATE_TRUNC(PARSE_DATE('%Y%m%d', t.event_date), MONTH) AS Month,
      item.item_name AS Product_Name,
      SUM(item.quantity) AS Quantity
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t,
    UNNEST(t.items) AS item
    WHERE t.user_pseudo_id IN (
      SELECT DISTINCT t2.user_pseudo_id
      FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t2,
      UNNEST(t2.items) AS item2
      WHERE item2.item_name = 'Google Red Speckled Tee'
        AND t2.event_date BETWEEN '20201101' AND '20210131'
    )
    AND item.item_name != 'Google Red Speckled Tee'
    AND t.event_date BETWEEN '20201101' AND '20210131'
    GROUP BY Month, Product_Name
  )
)
WHERE rn = 1
ORDER BY Month