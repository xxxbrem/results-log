WITH page_views AS (
  SELECT
    ep.value.string_value AS page_location,
    REGEXP_EXTRACT(ep.value.string_value, r'^https?://[^/]+(/.*)$') AS path
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS e,
    UNNEST(e.event_params) AS ep
  WHERE
    e.event_name = 'page_view' AND ep.key = 'page_location'
),
path_segments AS (
  SELECT
    page_location,
    SPLIT(TRIM(path, '/'), '/') AS segments
  FROM
    page_views
),
categories AS (
  SELECT REPLACE(LOWER(category), ' ', '+') AS category_name
  FROM UNNEST([
    'Accessories', 'Apparel', 'Brands', 'Campus Collection', 'Drinkware',
    'Electronics', 'Google Redesign', 'Lifestyle', 'Nest', 'New 2015 Logo',
    'Notebooks Journals', 'Office', 'Shop by Brand', 'Small Goods', 'Stationery', 'Wearables'
  ]) AS category
),
pdp_classification AS (
  SELECT
    page_location,
    ARRAY_LENGTH(segments) AS num_segments,
    LOWER(segments[SAFE_OFFSET(ARRAY_LENGTH(segments)-1)]) AS last_segment,
    LOWER(segments[SAFE_OFFSET(1)]) AS second_segment,
    LOWER(segments[SAFE_OFFSET(2)]) AS third_segment
  FROM
    path_segments
),
final_classification AS (
  SELECT
    *,
    CASE
      WHEN
        num_segments >= 3
        AND REGEXP_CONTAINS(last_segment, r'\+')
        AND (
          second_segment IN (SELECT category_name FROM categories)
          OR third_segment IN (SELECT category_name FROM categories)
        )
      THEN TRUE
      ELSE FALSE
    END AS is_pdp
  FROM
    pdp_classification
)
SELECT
  ROUND(100 * SUM(CASE WHEN is_pdp THEN 1 ELSE 0 END) / COUNT(*), 4) AS Percentage_of_PDP_page_views
FROM
  final_classification;