WITH
  page_view_events AS (
    SELECT
      (SELECT ep.value.string_value
       FROM UNNEST(event_params) AS ep
       WHERE ep.key = 'page_location') AS page_location
    FROM
      `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102`
    WHERE
      event_name = 'page_view'
  ),
  classified_pages AS (
    SELECT
      page_location,
      REGEXP_EXTRACT(page_location, r'https?://[^/]+(/.*)') AS url_path,
      SPLIT(TRIM(REGEXP_EXTRACT(page_location, r'https?://[^/]+(/.*)'), '/'), '/') AS segments
    FROM
      page_view_events
    WHERE
      page_location IS NOT NULL
  ),
  pdp_classified AS (
    SELECT
      COUNT(*) AS total_page_views,
      COUNTIF(
        ARRAY_LENGTH(segments) >= 3
        AND REGEXP_CONTAINS(segments[SAFE_OFFSET(ARRAY_LENGTH(segments) - 1)], r'\+')
        AND (
          LOWER(REPLACE(segments[SAFE_OFFSET(1)], '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection',
          'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
          'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
          OR
          LOWER(REPLACE(segments[SAFE_OFFSET(2)], '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection',
          'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
          'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
        )
      ) AS pdp_page_views
    FROM
      classified_pages
  )
SELECT
  ROUND((pdp_page_views / total_page_views) * 100, 4) AS Percentage_of_PDP_page_views
FROM
  pdp_classified;