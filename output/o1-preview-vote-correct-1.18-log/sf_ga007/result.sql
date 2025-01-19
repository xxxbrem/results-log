WITH page_views AS (
    SELECT
        ep.value:"value":"string_value"::STRING AS page_location
    FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE.EVENTS_20210102 t,
         LATERAL FLATTEN(input => t.EVENT_PARAMS) ep
    WHERE t.EVENT_NAME = 'page_view'
      AND ep.value:"key"::STRING = 'page_location'
      AND ep.value:"value":"string_value" IS NOT NULL
),
categories AS (
    SELECT 'accessories' AS category UNION ALL
    SELECT 'apparel' UNION ALL
    SELECT 'brands' UNION ALL
    SELECT 'campus collection' UNION ALL
    SELECT 'drinkware' UNION ALL
    SELECT 'electronics' UNION ALL
    SELECT 'google redesign' UNION ALL
    SELECT 'lifestyle' UNION ALL
    SELECT 'nest' UNION ALL
    SELECT 'new 2015 logo' UNION ALL
    SELECT 'notebooks journals' UNION ALL
    SELECT 'office' UNION ALL
    SELECT 'shop by brand' UNION ALL
    SELECT 'small goods' UNION ALL
    SELECT 'stationery' UNION ALL
    SELECT 'wearables'
),
pdp_page_views AS (
    SELECT
        page_location,
        SPLIT(page_location, '/') AS segments_array,
        ARRAY_SIZE(SPLIT(page_location, '/')) AS segments_count,
        SPLIT(page_location, '/')[4] AS segment4,
        SPLIT(page_location, '/')[5] AS segment5,
        SPLIT(page_location, '/')[ARRAY_SIZE(SPLIT(page_location, '/')) - 1] AS last_segment
    FROM page_views
),
pdp_criteria AS (
    SELECT
        COUNT(*) AS pdp_count
    FROM pdp_page_views pv
    WHERE
        pv.segments_count >= 5
        AND POSITION('+' IN pv.last_segment) > 0
        AND (
            LOWER(REPLACE(pv.segment4, '+', ' ')) IN (SELECT category FROM categories)
            OR LOWER(REPLACE(pv.segment5, '+', ' ')) IN (SELECT category FROM categories)
        )
),
total_page_views AS (
    SELECT COUNT(*) AS total_count
    FROM page_views
)
SELECT
    ROUND((pdp_criteria.pdp_count * 100.0) / total_page_views.total_count, 4) AS percentage
FROM pdp_criteria, total_page_views;