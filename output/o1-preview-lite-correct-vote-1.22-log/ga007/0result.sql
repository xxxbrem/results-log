SELECT
  ROUND(100 * COUNTIF(
    ARRAY_LENGTH(SPLIT(ep.value.string_value, '/')) >= 5
    AND CONTAINS_SUBSTR(
      ARRAY_REVERSE(SPLIT(ep.value.string_value, '/'))[SAFE_OFFSET(0)], '+'
    )
    AND (
      LOWER(REPLACE(SPLIT(ep.value.string_value, '/')[SAFE_OFFSET(3)], '+', ' ')) IN (
        'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
        'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
        'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
      )
      OR
      LOWER(REPLACE(SPLIT(ep.value.string_value, '/')[SAFE_OFFSET(4)], '+', ' ')) IN (
        'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
        'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
        'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
      )
    )
  ) / COUNT(*), 4) AS Percentage_of_PDP_page_views
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS t
CROSS JOIN UNNEST(t.event_params) AS ep
WHERE
  t.event_name = 'page_view'
  AND ep.key = 'page_location'
  AND ep.value.string_value IS NOT NULL;