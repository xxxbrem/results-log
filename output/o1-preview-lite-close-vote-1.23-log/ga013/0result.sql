WITH CategoryRegex AS (
  SELECT '(Accessories|Apparel|Brands|Campus\\+Collection|Drinkware|Electronics|Google\\+Redesign|Lifestyle|Nest|New\\+2015\\+Logo|Notebooks\\+Journals|Office|Shop\\+by\\+Brand|Small\\+Goods|Stationery|Wearables)' AS regex
),
PageData AS (
  SELECT
    e.event_timestamp,
    MAX(IF(ep.key = 'page_title', ep.value.string_value, NULL)) AS page_title,
    MAX(IF(ep.key = 'page_location', ep.value.string_value, NULL)) AS page_location
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210102` AS e
  LEFT JOIN UNNEST(e.event_params) AS ep
  ON TRUE
  WHERE e.user_pseudo_id = '1402138.5184246691'
    AND ep.key IN ('page_title', 'page_location')
  GROUP BY e.event_timestamp
)
SELECT
  COALESCE(page_title, page_location) AS Page_Name,
  CASE
    WHEN ARRAY_LENGTH(segments) >= 5
      AND (
        REGEXP_CONTAINS(segments[SAFE_OFFSET(3)], CategoryRegex.regex)
        OR REGEXP_CONTAINS(segments[SAFE_OFFSET(4)], CategoryRegex.regex)
      )
      AND NOT REGEXP_CONTAINS(segments[SAFE_OFFSET(3)], '\\+')
      AND NOT REGEXP_CONTAINS(segments[SAFE_OFFSET(4)], '\\+')
    THEN 'PLP'
    WHEN ARRAY_LENGTH(segments) >= 5
      AND (
        REGEXP_CONTAINS(segments[SAFE_OFFSET(3)], CategoryRegex.regex)
        OR REGEXP_CONTAINS(segments[SAFE_OFFSET(4)], CategoryRegex.regex)
      )
      AND REGEXP_CONTAINS(segments[SAFE_OFFSET(4)], '\\+')
    THEN 'PDP'
    ELSE 'Other'
  END AS Page_Type
FROM (
  SELECT *,
    SPLIT(REGEXP_REPLACE(page_location, r'^https?://[^/]+', ''), '/') AS segments
  FROM PageData
), CategoryRegex
ORDER BY event_timestamp;