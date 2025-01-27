WITH
  page_views AS (
    SELECT
      t.user_pseudo_id,
      ep_ga.value.int_value AS ga_session_id,
      ep_pl.value.string_value AS page_location,
      REGEXP_REPLACE(REGEXP_EXTRACT(ep_pl.value.string_value, r'https?://[^/]+(/.*)'), '^/', '') AS path,
      SPLIT(REGEXP_REPLACE(REGEXP_EXTRACT(ep_pl.value.string_value, r'https?://[^/]+(/.*)'), '^/', ''), '/') AS segments
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS t
      LEFT JOIN UNNEST(t.event_params) AS ep_ga ON ep_ga.key = 'ga_session_id'
      LEFT JOIN UNNEST(t.event_params) AS ep_pl ON ep_pl.key = 'page_location'
    WHERE
      t.event_name = 'page_view'
  ),
  page_types AS (
    SELECT
      user_pseudo_id,
      ga_session_id,
      page_location,
      CASE
        WHEN ARRAY_LENGTH(segments) >= 2
          AND NOT REGEXP_CONTAINS(segments[SAFE_OFFSET(1)], r'\+')
          AND LOWER(REPLACE(segments[SAFE_OFFSET(1)], '+', ' ')) IN (
            'accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics',
            'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals',
            'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
          THEN 'PLP'
        WHEN ARRAY_LENGTH(segments) >= 3
          AND REGEXP_CONTAINS(segments[SAFE_OFFSET(ARRAY_LENGTH(segments) - 1)], r'\+')
          AND LOWER(REPLACE(segments[SAFE_OFFSET(1)], '+', ' ')) IN (
            'accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics',
            'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals',
            'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
          THEN 'PDP'
        ELSE 'Other'
      END AS page_type
    FROM
      page_views
  ),
  session_page_types AS (
    SELECT
      ga_session_id,
      MAX(IF(page_type = 'PLP', 1, 0)) AS viewed_plp,
      MAX(IF(page_type = 'PDP', 1, 0)) AS viewed_pdp
    FROM
      page_types
    GROUP BY
      ga_session_id
  )
SELECT
  ROUND((COUNTIF(viewed_plp = 1 AND viewed_pdp = 1) * 100.0) / NULLIF(COUNT(*), 0), 4) AS Percentage
FROM
  session_page_types;