SELECT
  page_title AS Page_Name,
  CASE
    WHEN ARRAY_LENGTH(url_segments) >= 5
      AND NOT (
        CONTAINS_SUBSTR(url_segments[SAFE_OFFSET(3)], '+') OR
        CONTAINS_SUBSTR(url_segments[SAFE_OFFSET(4)], '+')
      )
      AND (
        LOWER(url_segments[SAFE_OFFSET(3)]) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus+collection',
          'drinkware', 'electronics', 'google+redesign', 'lifestyle',
          'nest', 'new+2015+logo', 'notebooks+journals', 'office',
          'shop+by+brand', 'small+goods', 'stationery', 'wearables'
        ]) OR
        LOWER(url_segments[SAFE_OFFSET(4)]) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus+collection',
          'drinkware', 'electronics', 'google+redesign', 'lifestyle',
          'nest', 'new+2015+logo', 'notebooks+journals', 'office',
          'shop+by+brand', 'small+goods', 'stationery', 'wearables'
        ])
      )
    THEN 'PLP'
    WHEN ARRAY_LENGTH(url_segments) >= 5
      AND CONTAINS_SUBSTR(url_segments[ORDINAL(ARRAY_LENGTH(url_segments))], '+')
      AND (
        LOWER(url_segments[SAFE_OFFSET(3)]) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus+collection',
          'drinkware', 'electronics', 'google+redesign', 'lifestyle',
          'nest', 'new+2015+logo', 'notebooks+journals', 'office',
          'shop+by+brand', 'small+goods', 'stationery', 'wearables'
        ]) OR
        LOWER(url_segments[SAFE_OFFSET(4)]) IN UNNEST([
          'accessories', 'apparel', 'brands', 'campus+collection',
          'drinkware', 'electronics', 'google+redesign', 'lifestyle',
          'nest', 'new+2015+logo', 'notebooks+journals', 'office',
          'shop+by+brand', 'small+goods', 'stationery', 'wearables'
        ])
      )
    THEN 'PDP'
    ELSE 'Other'
  END AS Page_Type
FROM (
  SELECT
    e.event_timestamp,
    MAX(CASE WHEN ep.key = 'page_title' THEN ep.value.string_value END) AS page_title,
    SPLIT(
      REGEXP_REPLACE(
        MAX(CASE WHEN ep.key = 'page_location' THEN ep.value.string_value END),
        r'^https?://[^/]+',
        ''
      ),
      '/'
    ) AS url_segments
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS e
  CROSS JOIN UNNEST(e.event_params) AS ep
  WHERE
    e.user_pseudo_id = '1402138.5184246691'
    AND e.event_name = 'page_view'
    AND e.event_date = '20210102'
  GROUP BY e.event_timestamp
)