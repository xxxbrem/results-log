SELECT
    MS."StyleName",
    SUM(CASE WHEN MP."PreferenceSeq" = 1 THEN 1 ELSE 0 END) AS first_preference_count,
    SUM(CASE WHEN MP."PreferenceSeq" = 2 THEN 1 ELSE 0 END) AS second_preference_count,
    SUM(CASE WHEN MP."PreferenceSeq" = 3 THEN 1 ELSE 0 END) AS third_preference_count
FROM
    ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."MUSICAL_STYLES" AS MS
LEFT JOIN
    ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."MUSICAL_PREFERENCES" AS MP
    ON MS."StyleID" = MP."StyleID"
GROUP BY
    MS."StyleName"
ORDER BY
    MS."StyleName";