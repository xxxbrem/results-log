SELECT ms."StyleName",
       COALESCE(SUM(CASE WHEN mp."PreferenceSeq" = 1 THEN 1 ELSE 0 END), 0) AS "FirstPreferenceCount",
       COALESCE(SUM(CASE WHEN mp."PreferenceSeq" = 2 THEN 1 ELSE 0 END), 0) AS "SecondPreferenceCount",
       COALESCE(SUM(CASE WHEN mp."PreferenceSeq" = 3 THEN 1 ELSE 0 END), 0) AS "ThirdPreferenceCount"
FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.MUSICAL_STYLES ms
LEFT JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.MUSICAL_PREFERENCES mp
  ON ms."StyleID" = mp."StyleID"
GROUP BY ms."StyleName"
ORDER BY ms."StyleName";