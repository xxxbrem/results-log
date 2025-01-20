WITH page_views AS (
  SELECT t."EVENT_PARAMS"
  FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t
  WHERE t."EVENT_NAME" = 'page_view'
),
page_locations AS (
  SELECT
    f.value:"value"::STRING AS "page_location"
  FROM page_views t,
       LATERAL FLATTEN(input => t."EVENT_PARAMS") f
  WHERE f.value:"key" = 'page_location'
),
urls AS (
  SELECT
    "page_location",
    SPLIT("page_location", '/') AS url_segments
  FROM page_locations
),
pdp_page_views AS (
  SELECT *
  FROM urls
  WHERE
    ARRAY_SIZE(url_segments) >= 6
    AND POSITION('+', url_segments[5]) > 0
    AND (
      LOWER(REPLACE(url_segments[3], '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
      OR LOWER(REPLACE(url_segments[4], '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
    )
),
total_counts AS (
  SELECT
    COUNT(*) AS total_page_views,
    (SELECT COUNT(*) FROM pdp_page_views) AS pdp_page_views
  FROM page_locations
)
SELECT
  ROUND(pdp_page_views::FLOAT / total_page_views * 100, 4) AS percentage_pdp_page_views
FROM total_counts;