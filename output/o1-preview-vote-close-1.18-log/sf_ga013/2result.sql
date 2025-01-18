SELECT
    e."PAGE_TITLE" AS "Page_Name",
    CASE
        WHEN ARRAY_SIZE(segments) >= 5
            AND NOT CONTAINS(GET(segments, 4), '+')
            AND NOT CONTAINS(GET(segments, 5), '+')
            AND (
                LOWER(REPLACE(GET(segments, 4), '+', ' ')) IN (
                    'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
                    'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
                    'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
                )
                OR LOWER(REPLACE(GET(segments, 5), '+', ' ')) IN (
                    'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
                    'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
                    'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
                )
            )
            THEN 'PLP'
        WHEN ARRAY_SIZE(segments) >= 5
            AND CONTAINS(GET(segments, ARRAY_SIZE(segments)), '+')
            AND (
                LOWER(REPLACE(GET(segments, 4), '+', ' ')) IN (
                    'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
                    'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
                    'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
                )
                OR LOWER(REPLACE(GET(segments, 5), '+', ' ')) IN (
                    'accessories', 'apparel', 'brands', 'campus collection', 'drinkware',
                    'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
                    'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables'
                )
            )
            THEN 'PDP'
        ELSE 'Other'
    END AS "Page_Type"
FROM
    (
        SELECT
            t."EVENT_TIMESTAMP",
            MAX(CASE WHEN f.value:"key"::STRING = 'page_title' THEN f.value:"value"::VARIANT:"string_value"::STRING END) AS "PAGE_TITLE",
            MAX(CASE WHEN f.value:"key"::STRING = 'page_location' THEN f.value:"value"::VARIANT:"string_value"::STRING END) AS "PAGE_LOCATION"
        FROM
            "GA4"."GA4_OBFUSCATED_SAMPLE_ECOMMERCE"."EVENTS_20210102" t,
            LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE
            t."USER_PSEUDO_ID" = '1402138.5184246691'
            AND t."EVENT_DATE" = '20210102'
            AND t."EVENT_NAME" = 'page_view'
        GROUP BY
            t."EVENT_TIMESTAMP"
    ) e,
    LATERAL (
        SELECT SPLIT(PARSE_URL(e."PAGE_LOCATION")['path']::STRING, '/') AS segments
    )
ORDER BY
    e."EVENT_TIMESTAMP";