SELECT
  COALESCE(REGEXP_REPLACE(ep_page_location.value.string_value, r'^https?://[^/]+', ''), '/') AS Page_Path,
  ep_page_title.value.string_value AS Page_Title,
  COUNT(*) AS Pageviews
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t
JOIN UNNEST(t.event_params) AS ep_page_location ON ep_page_location.key = 'page_location'
JOIN UNNEST(t.event_params) AS ep_page_title ON ep_page_title.key = 'page_title'
WHERE
  t.event_name = 'page_view'
  AND t.event_date BETWEEN '20201201' AND '20201231'
  AND REGEXP_EXTRACT(ep_page_location.value.string_value, r'^https?://([^/]+)') = 'shop.googlemerchandisestore.com'
GROUP BY Page_Path, Page_Title
ORDER BY Pageviews DESC
LIMIT 1;