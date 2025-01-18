WITH EntertainerTop2Styles AS (
  SELECT
    "EntertainerID",
    "EntStageName",
    MAX(CASE WHEN rn = 1 THEN "StyleID" END) AS "Style1ID",
    MAX(CASE WHEN rn = 2 THEN "StyleID" END) AS "Style2ID"
  FROM (
    SELECT
      e."EntertainerID",
      e."EntStageName",
      es."StyleID",
      ROW_NUMBER() OVER (
        PARTITION BY es."EntertainerID"
        ORDER BY es."StyleStrength" DESC NULLS LAST
      ) AS rn
    FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.ENTERTAINERS e
    JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.ENTERTAINER_STYLES es
      ON e."EntertainerID" = es."EntertainerID"
  )
  WHERE rn <= 2
  GROUP BY "EntertainerID", "EntStageName"
),
CustomerTop2Preferences AS (
  SELECT
    "CustomerID",
    "CustLastName",
    MAX(CASE WHEN rn = 1 THEN "StyleID" END) AS "Pref1ID",
    MAX(CASE WHEN rn = 2 THEN "StyleID" END) AS "Pref2ID"
  FROM (
    SELECT
      c."CustomerID",
      c."CustLastName",
      mp."StyleID",
      ROW_NUMBER() OVER (
        PARTITION BY mp."CustomerID"
        ORDER BY mp."PreferenceSeq" ASC NULLS LAST
      ) AS rn
    FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.CUSTOMERS c
    JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY.MUSICAL_PREFERENCES mp
      ON c."CustomerID" = mp."CustomerID"
    WHERE mp."PreferenceSeq" IN (1,2)
  )
  WHERE rn <= 2
  GROUP BY "CustomerID", "CustLastName"
)
SELECT DISTINCT e."EntStageName", c."CustLastName"
FROM EntertainerTop2Styles e
JOIN CustomerTop2Preferences c
ON
  (
    (e."Style1ID" = c."Pref1ID" AND e."Style2ID" = c."Pref2ID") OR
    (e."Style1ID" = c."Pref2ID" AND e."Style2ID" = c."Pref1ID")
  );