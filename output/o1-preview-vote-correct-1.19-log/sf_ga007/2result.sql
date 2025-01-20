WITH page_views AS (
  SELECT
    t."EVENT_TIMESTAMP",
    f.VALUE:"value":"string_value"::STRING AS page_url
  FROM
    GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t,
    LATERAL FLATTEN(INPUT => t."EVENT_PARAMS") f
  WHERE
    t."EVENT_NAME" = 'page_view'
    AND f.VALUE:"key"::STRING = 'page_location'
)
SELECT
  ROUND((SUM(CASE WHEN is_pdp THEN 1 ELSE 0 END)::FLOAT / COUNT(*)::FLOAT) * 100, 4) AS "percentage_pdp_page_views"
FROM (
  SELECT
    EVENT_TIMESTAMP,
    page_url,
    ARRAY_SIZE(SPLIT(page_url, '/')) AS num_segments,
    REGEXP_SUBSTR(page_url, '[^/]+$') AS last_segment,
    SPLIT(page_url, '/') AS segments,
    CASE
      WHEN
        ARRAY_SIZE(SPLIT(page_url, '/')) >= 5
        AND POSITION('+', last_segment) > 0
        AND (
          COALESCE(segments[3], '') IN ('Accessories', 'Apparel', 'Brands', 'Campus Collection', 'Drinkware', 'Electronics', 'Google Redesign', 'Lifestyle', 'Nest', 'New 2015 Logo', 'Notebooks Journals', 'Office', 'Shop by Brand', 'Small Goods', 'Stationery', 'Wearables')
          OR
          COALESCE(segments[4], '') IN ('Accessories', 'Apparel', 'Brands', 'Campus Collection', 'Drinkware', 'Electronics', 'Google Redesign', 'Lifestyle', 'Nest', 'New 2015 Logo', 'Notebooks Journals', 'Office', 'Shop by Brand', 'Small Goods', 'Stationery', 'Wearables')
        )
      THEN TRUE
      ELSE FALSE
    END AS is_pdp
  FROM page_views
);