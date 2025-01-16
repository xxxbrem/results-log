SELECT COUNT(*) AS "number_of_pseudo_users"
FROM (
    SELECT DISTINCT "USER_PSEUDO_ID"
    FROM (
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210101" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
        UNION
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210102" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
        UNION
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210103" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
        UNION
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210104" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
        UNION
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210105" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
    )
    EXCEPT
    SELECT DISTINCT "USER_PSEUDO_ID"
    FROM (
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210106" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
        UNION
        SELECT t."USER_PSEUDO_ID"
        FROM GA4.GA4_OBFUSCATED_SAMPLE_ECOMMERCE."EVENTS_20210107" t,
        LATERAL FLATTEN(input => t."EVENT_PARAMS") f
        WHERE f.value:"key"::STRING = 'engagement_time_msec'
    )
);