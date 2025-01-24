WITH
       -- Subquery to count push notification sends
       sends AS (
           SELECT
               "APP_GROUP_ID",
               "CAMPAIGN_ID",
               "USER_ID",
               "MESSAGE_VARIATION_ID",
               "PLATFORM",
               "AD_TRACKING_ENABLED",
               NULL AS "CARRIER",
               NULL AS "BROWSER",
               NULL AS "DEVICE_MODEL",
               COUNT(*) AS "push_notification_sends",
               COUNT(DISTINCT "USER_ID") AS "unique_push_notification_sends"
           FROM "BRAZE_USER_EVENT_DEMO_DATASET"."PUBLIC"."USERS_MESSAGES_PUSHNOTIFICATION_SEND_VIEW"
           WHERE "SF_CREATED_AT" >= '2021-12-14 11:15:00' AND "SF_CREATED_AT" < '2021-12-14 11:18:00'
           GROUP BY 1, 2, 3, 4, 5, 6
       ),
       -- Subquery to count push notification bounces
       bounces AS (
           SELECT
               "APP_GROUP_ID",
               "CAMPAIGN_ID",
               "USER_ID",
               "MESSAGE_VARIATION_ID",
               "PLATFORM",
               "AD_TRACKING_ENABLED",
               NULL AS "CARRIER",
               NULL AS "BROWSER",
               NULL AS "DEVICE_MODEL",
               COUNT(*) AS "push_notification_bounced",
               COUNT(DISTINCT "USER_ID") AS "unique_push_notification_bounced"
           FROM "BRAZE_USER_EVENT_DEMO_DATASET"."PUBLIC"."USERS_MESSAGES_PUSHNOTIFICATION_BOUNCE_VIEW"
           WHERE "SF_CREATED_AT" >= '2021-12-14 11:15:00' AND "SF_CREATED_AT" < '2021-12-14 11:18:00'
           GROUP BY 1, 2, 3, 4, 5, 6
       ),
       -- Subquery to count push notification opens
       opens AS (
           SELECT
               "APP_GROUP_ID",
               "CAMPAIGN_ID",
               "USER_ID",
               "MESSAGE_VARIATION_ID",
               "PLATFORM",
               "AD_TRACKING_ENABLED",
               "CARRIER",
               "BROWSER",
               "DEVICE_MODEL",
               COUNT(*) AS "push_notification_open",
               COUNT(DISTINCT "USER_ID") AS "unique_push_notification_opened"
           FROM "BRAZE_USER_EVENT_DEMO_DATASET"."PUBLIC"."USERS_MESSAGES_PUSHNOTIFICATION_OPEN_VIEW"
           WHERE "SF_CREATED_AT" >= '2021-12-14 11:15:00' AND "SF_CREATED_AT" < '2021-12-14 11:18:00'
           GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
       ),
       -- Subquery to count push notification influenced opens
       influenced_opens AS (
           SELECT
               "APP_GROUP_ID",
               "CAMPAIGN_ID",
               "USER_ID",
               "MESSAGE_VARIATION_ID",
               "PLATFORM",
               NULL AS "AD_TRACKING_ENABLED",
               "CARRIER",
               "BROWSER",
               "DEVICE_MODEL",
               COUNT(*) AS "push_notification_influenced_open",
               COUNT(DISTINCT "USER_ID") AS "unique_push_notification_influenced_open"
           FROM "BRAZE_USER_EVENT_DEMO_DATASET"."PUBLIC"."USERS_MESSAGES_PUSHNOTIFICATION_INFLUENCEDOPEN_VIEW"
           WHERE "SF_CREATED_AT" >= '2021-12-14 11:15:00' AND "SF_CREATED_AT" < '2021-12-14 11:18:00'
           GROUP BY 1, 2, 3, 4, 5, 7, 8, 9
       )
   SELECT
       COALESCE(s."APP_GROUP_ID", b."APP_GROUP_ID", o."APP_GROUP_ID", io."APP_GROUP_ID") AS "App_Group_ID",
       COALESCE(s."CAMPAIGN_ID", b."CAMPAIGN_ID", o."CAMPAIGN_ID", io."CAMPAIGN_ID") AS "Campaign_ID",
       COALESCE(s."USER_ID", b."USER_ID", o."USER_ID", io."USER_ID") AS "User_ID",
       COALESCE(s."MESSAGE_VARIATION_ID", b."MESSAGE_VARIATION_ID", o."MESSAGE_VARIATION_ID", io."MESSAGE_VARIATION_ID") AS "Message_Variation_ID",
       COALESCE(s."PLATFORM", b."PLATFORM", o."PLATFORM", io."PLATFORM") AS "Platform",
       COALESCE(s."AD_TRACKING_ENABLED", b."AD_TRACKING_ENABLED", o."AD_TRACKING_ENABLED") AS "Ad_Tracking_Enabled",
       COALESCE(o."CARRIER", io."CARRIER") AS "Carrier",
       COALESCE(o."BROWSER", io."BROWSER") AS "Browser",
       COALESCE(o."DEVICE_MODEL", io."DEVICE_MODEL") AS "Device_Model",
       COALESCE(s."push_notification_sends", 0) AS "push_notification_sends",
       COALESCE(s."unique_push_notification_sends", 0) AS "unique_push_notification_sends",
       COALESCE(b."push_notification_bounced", 0) AS "push_notification_bounced",
       COALESCE(b."unique_push_notification_bounced", 0) AS "unique_push_notification_bounced",
       COALESCE(o."push_notification_open", 0) AS "push_notification_open",
       COALESCE(o."unique_push_notification_opened", 0) AS "unique_push_notification_opened",
       COALESCE(io."push_notification_influenced_open", 0) AS "push_notification_influenced_open",
       COALESCE(io."unique_push_notification_influenced_open", 0) AS "unique_push_notification_influenced_open"
   FROM sends s
   FULL OUTER JOIN bounces b ON
       s."APP_GROUP_ID" = b."APP_GROUP_ID" AND
       s."CAMPAIGN_ID" = b."CAMPAIGN_ID" AND
       s."USER_ID" = b."USER_ID" AND
       s."MESSAGE_VARIATION_ID" = b."MESSAGE_VARIATION_ID" AND
       s."PLATFORM" = b."PLATFORM" AND
       s."AD_TRACKING_ENABLED" = b."AD_TRACKING_ENABLED"
   FULL OUTER JOIN opens o ON
       COALESCE(s."APP_GROUP_ID", b."APP_GROUP_ID") = o."APP_GROUP_ID" AND
       COALESCE(s."CAMPAIGN_ID", b."CAMPAIGN_ID") = o."CAMPAIGN_ID" AND
       COALESCE(s."USER_ID", b."USER_ID") = o."USER_ID" AND
       COALESCE(s."MESSAGE_VARIATION_ID", b."MESSAGE_VARIATION_ID") = o."MESSAGE_VARIATION_ID" AND
       COALESCE(s."PLATFORM", b."PLATFORM") = o."PLATFORM" AND
       COALESCE(s."AD_TRACKING_ENABLED", b."AD_TRACKING_ENABLED") = o."AD_TRACKING_ENABLED"
   FULL OUTER JOIN influenced_opens io ON
       COALESCE(s."APP_GROUP_ID", b."APP_GROUP_ID", o."APP_GROUP_ID") = io."APP_GROUP_ID" AND
       COALESCE(s."CAMPAIGN_ID", b."CAMPAIGN_ID", o."CAMPAIGN_ID") = io."CAMPAIGN_ID" AND
       COALESCE(s."USER_ID", b."USER_ID", o."USER_ID") = io."USER_ID" AND
       COALESCE(s."MESSAGE_VARIATION_ID", b."MESSAGE_VARIATION_ID", o."MESSAGE_VARIATION_ID") = io."MESSAGE_VARIATION_ID" AND
       COALESCE(s."PLATFORM", b."PLATFORM", o."PLATFORM") = io."PLATFORM";