WITH all_events AS (
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201201`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201202`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201203`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201204`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201205`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201206`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201207`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201208`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201209`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201210`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201211`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201212`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201213`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201214`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201215`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201216`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201217`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201218`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201219`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201220`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201221`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201222`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201223`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201224`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201225`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201226`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201227`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201228`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201229`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201230`
    UNION ALL
    SELECT user_pseudo_id, event_name
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
)

SELECT
  ROUND(
    (SELECT AVG(pageview_count) FROM (
        SELECT user_pseudo_id,
               COUNTIF(event_name = 'page_view') AS pageview_count
        FROM all_events
        GROUP BY user_pseudo_id
        HAVING COUNTIF(event_name = 'purchase') > 0
    ))
    -
    (SELECT AVG(pageview_count) FROM (
        SELECT user_pseudo_id,
               COUNTIF(event_name = 'page_view') AS pageview_count
        FROM all_events
        GROUP BY user_pseudo_id
        HAVING COUNTIF(event_name = 'purchase') = 0
    )),
    4
  ) AS Difference_in_Average_Pageviews