SELECT
   s."StyleName",
   SUM(CASE WHEN p."PreferenceSeq" = 1 THEN 1 ELSE 0 END) AS "FirstPreferenceCount",
   SUM(CASE WHEN p."PreferenceSeq" = 2 THEN 1 ELSE 0 END) AS "SecondPreferenceCount",
   SUM(CASE WHEN p."PreferenceSeq" = 3 THEN 1 ELSE 0 END) AS "ThirdPreferenceCount"
FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."MUSICAL_STYLES" s
LEFT JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."MUSICAL_PREFERENCES" p
  ON s."StyleID" = p."StyleID"
GROUP BY s."StyleName"
ORDER BY s."StyleName";