WITH events AS (
  SELECT
    t."EVENT_TIMESTAMP",
    t."EVENT_PARAMS"
  FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t
  WHERE t."USER_PSEUDO_ID" = '1402138.5184246691'
    AND t."EVENT_NAME" = 'page_view'
),
event_params AS (
  SELECT
    e."EVENT_TIMESTAMP",
    ep.value:"key"::STRING AS param_key,
    CASE
      WHEN ep.value:"value":"string_value" IS NOT NULL THEN ep.value:"value":"string_value"::STRING
      WHEN ep.value:"value":"int_value" IS NOT NULL THEN TO_VARCHAR(ep.value:"value":"int_value")
      WHEN ep.value:"value":"float_value" IS NOT NULL THEN TO_VARCHAR(ep.value:"value":"float_value")
      ELSE NULL
    END AS param_value
  FROM events e,
       LATERAL FLATTEN(input => e."EVENT_PARAMS") ep
),
pivoted_params AS (
  SELECT
    "EVENT_TIMESTAMP",
    MAX(CASE WHEN param_key = 'page_title' THEN param_value END) AS "Page_Name",
    MAX(CASE WHEN param_key = 'page_location' THEN param_value END) AS "Page_URL"
  FROM event_params
  GROUP BY "EVENT_TIMESTAMP"
),
parsed_urls AS (
  SELECT
    "Page_Name",
    "Page_URL",
    SPLIT(PARSE_URL("Page_URL")['path']::STRING, '/') AS url_segments
  FROM pivoted_params
),
classified_pages AS (
  SELECT
    "Page_Name",
    CASE
      WHEN
        ARRAY_SIZE(url_segments) >= 3
        AND POSITION('+' IN url_segments[2]) = 0
        AND (
          LOWER(url_segments[1]) IN ('accessories', 'apparel', 'brands', 'campus collection',
            'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
            'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
          OR LOWER(url_segments[2]) IN ('accessories', 'apparel', 'brands', 'campus collection',
            'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
            'notebooks journals', 'office','shop by brand', 'small goods', 'stationery', 'wearables')
        )
      THEN 'PLP'
      WHEN
        ARRAY_SIZE(url_segments) >= 3
        AND POSITION('+' IN url_segments[ARRAY_SIZE(url_segments)]) > 0
        AND (
          LOWER(url_segments[1]) IN ('accessories', 'apparel', 'brands', 'campus collection',
            'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
            'notebooks journals', 'office','shop by brand', 'small goods', 'stationery', 'wearables')
          OR LOWER(url_segments[2]) IN ('accessories', 'apparel', 'brands', 'campus collection',
            'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo',
            'notebooks journals', 'office','shop by brand', 'small goods', 'stationery', 'wearables')
        )
      THEN 'PDP'
      ELSE 'Other'
    END AS "Page_Type"
  FROM parsed_urls
)
SELECT DISTINCT "Page_Name", "Page_Type"
FROM classified_pages;