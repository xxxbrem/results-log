WITH page_view_events AS (
    SELECT
        t.*,
        f.value['value']['string_value']::string AS page_location
    FROM
        GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
    WHERE
        t."EVENT_NAME" = 'page_view'
        AND t."EVENT_DATE" = '20210102'
        AND f.value['key']::string = 'page_location'
),
processed_events AS (
    SELECT
        *,
        SPLIT(REGEXP_REPLACE(page_location, '^https?://', ''), '/') AS segments
    FROM page_view_events
),
category_list AS (
    SELECT 'Accessories' AS category_name UNION ALL
    SELECT 'Apparel' UNION ALL
    SELECT 'Brands' UNION ALL
    SELECT 'Campus Collection' UNION ALL
    SELECT 'Drinkware' UNION ALL
    SELECT 'Electronics' UNION ALL
    SELECT 'Google Redesign' UNION ALL
    SELECT 'Lifestyle' UNION ALL
    SELECT 'Nest' UNION ALL
    SELECT 'New 2015 Logo' UNION ALL
    SELECT 'Notebooks Journals' UNION ALL
    SELECT 'Office' UNION ALL
    SELECT 'Shop by Brand' UNION ALL
    SELECT 'Small Goods' UNION ALL
    SELECT 'Stationery' UNION ALL
    SELECT 'Wearables'
),
pdp_events AS (
    SELECT
        *,
        ARRAY_SIZE(segments) AS num_segments,
        segments[num_segments -1] AS last_segment,
        segments[4] AS fifth_segment,  -- segments index starts from 0
        segments[3] AS fourth_segment,
        CASE WHEN
            page_location IS NOT NULL
            AND num_segments >= 5
            AND POSITION('+', last_segment) > 0
            AND (
                REPLACE(fourth_segment, '+', ' ') IN (SELECT category_name FROM category_list)
                OR
                REPLACE(fifth_segment, '+', ' ') IN (SELECT category_name FROM category_list)
            )
        THEN TRUE
        ELSE FALSE
        END AS is_pdp
    FROM processed_events
)
SELECT
    ROUND(COUNT(CASE WHEN is_pdp THEN 1 END) * 100.0 / COUNT(*), 4) AS Percentage
FROM pdp_events;