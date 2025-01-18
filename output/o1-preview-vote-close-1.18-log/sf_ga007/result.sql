SELECT 
  (
    COUNT( 
      CASE WHEN 
        ARRAY_SIZE(SPLIT(SPLIT_PART(ep.value:"value":"string_value"::STRING, '?', 1), '/')) >= 5
        AND POSITION('+' IN SPLIT_PART(SPLIT_PART(ep.value:"value":"string_value"::STRING, '?', 1), '/', -1)) > 0
        AND (
          LOWER(REPLACE(SPLIT_PART(SPLIT_PART(ep.value:"value":"string_value"::STRING, '?', 1), '/', 4), '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
          OR
          LOWER(REPLACE(SPLIT_PART(SPLIT_PART(ep.value:"value":"string_value"::STRING, '?', 1), '/', 5), '+', ' ')) IN ('accessories', 'apparel', 'brands', 'campus collection', 'drinkware', 'electronics', 'google redesign', 'lifestyle', 'nest', 'new 2015 logo', 'notebooks journals', 'office', 'shop by brand', 'small goods', 'stationery', 'wearables')
        )
      THEN 1 END
    ) * 100.0 / COUNT(*)
  ) AS "Percentage_of_Page_Views_for_PDP"
FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t
, LATERAL FLATTEN(input => t."EVENT_PARAMS") ep
WHERE t."EVENT_NAME" = 'page_view'
  AND ep.value:"key"::STRING = 'page_location'
  AND ep.value:"value":"string_value" IS NOT NULL;