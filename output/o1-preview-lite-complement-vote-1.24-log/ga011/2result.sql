SELECT
  REGEXP_EXTRACT(
    (SELECT ep.value.string_value FROM UNNEST(t.event_params) AS ep WHERE ep.key = 'page_location'),
    'https?://[^/]+(.*)$'
  ) AS page_path,
  (SELECT ep.value.string_value FROM UNNEST(t.event_params) AS ep WHERE ep.key = 'page_title') AS page_title,
  COUNT(*) AS pageviews
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_202012*` AS t
WHERE
  t.event_name = 'page_view'
  AND EXISTS (
    SELECT 1 FROM UNNEST(t.event_params) AS ep
    WHERE ep.key = 'page_location' AND ep.value.string_value LIKE '%shop.googlemerchandisestore.com%'
  )
GROUP BY
  page_path,
  page_title
ORDER BY
  pageviews DESC
LIMIT 1;