SELECT 
    S."StyleID",
    S."StyleName",
    SUM(CASE WHEN P."PreferenceSeq" = 1 THEN 1 ELSE 0 END) AS "FirstPreferenceCount",
    SUM(CASE WHEN P."PreferenceSeq" = 2 THEN 1 ELSE 0 END) AS "SecondPreferenceCount",
    SUM(CASE WHEN P."PreferenceSeq" = 3 THEN 1 ELSE 0 END) AS "ThirdPreferenceCount"
FROM
    ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.MUSICAL_STYLES AS S
LEFT JOIN
    ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.MUSICAL_PREFERENCES AS P
ON
    S."StyleID" = P."StyleID"
GROUP BY
    S."StyleID", S."StyleName"
ORDER BY
    S."StyleID" ASC
;