WITH most_visited_page AS (
  SELECT ep.value.string_value AS page_title,
         COUNT(*) AS view_count
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t
  JOIN UNNEST(t.event_params) AS ep
  WHERE t.event_name = 'page_view'
    AND ep.key = 'page_title'
    AND _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
  GROUP BY page_title
  ORDER BY view_count DESC
  LIMIT 1
)
SELECT COUNT(DISTINCT t.user_pseudo_id) AS number_of_distinct_users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t
JOIN UNNEST(t.event_params) AS ep
JOIN most_visited_page mvp
  ON ep.value.string_value = mvp.page_title
WHERE t.event_name = 'page_view'
  AND ep.key = 'page_title'
  AND _TABLE_SUFFIX BETWEEN '20210101' AND '20210131';