SELECT
  ROUND((pdp.total_pdp_views / total.total_views) * 100, 4) AS Percentage_of_PDP_page_views
FROM
  (
    SELECT COUNT(*) AS total_views
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
    WHERE event_name = 'page_view'
  ) AS total,
  (
    SELECT COUNT(*) AS total_pdp_views
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS t,
    UNNEST(t.event_params) AS ep
    WHERE t.event_name = 'page_view'
      AND ep.key = 'page_location'
      AND ARRAY_LENGTH(SPLIT(ep.value.string_value, '/')) >= 5
      AND REGEXP_CONTAINS(
        SPLIT(ep.value.string_value, '/')[OFFSET(ARRAY_LENGTH(SPLIT(ep.value.string_value, '/')) - 1)],
        r'\+'
      )
      AND (
        LOWER(REPLACE(SPLIT(ep.value.string_value, '/')[OFFSET(3)], '+', ' ')) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics',
          'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals',
          'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
        ])
        OR
        LOWER(REPLACE(SPLIT(ep.value.string_value, '/')[OFFSET(4)], '+', ' ')) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics',
          'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals',
          'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
        ])
      )
  ) AS pdp;