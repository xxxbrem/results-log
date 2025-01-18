WITH EntTopStyles AS (
  SELECT
    es."EntertainerID",
    MAX(CASE WHEN es.rn = 1 THEN es."StyleID" END) AS "EntStyleID1",
    MAX(CASE WHEN es.rn = 2 THEN es."StyleID" END) AS "EntStyleID2"
  FROM (
    SELECT
      es."EntertainerID",
      es."StyleID",
      ROW_NUMBER() OVER (
        PARTITION BY es."EntertainerID"
        ORDER BY es."StyleStrength" DESC NULLS LAST, es."StyleID"
      ) AS rn
    FROM
      "ENTERTAINMENTAGENCY"."ENTERTAINMENTAGENCY"."ENTERTAINER_STYLES" es
  ) es
  GROUP BY es."EntertainerID"
  HAVING COUNT(*) >= 2
),
CustTopStyles AS (
  SELECT
    mp."CustomerID",
    MAX(CASE WHEN mp.rn = 1 THEN mp."StyleID" END) AS "CustStyleID1",
    MAX(CASE WHEN mp.rn = 2 THEN mp."StyleID" END) AS "CustStyleID2"
  FROM (
    SELECT
      mp."CustomerID",
      mp."StyleID",
      ROW_NUMBER() OVER (
        PARTITION BY mp."CustomerID"
        ORDER BY mp."PreferenceSeq" ASC NULLS LAST, mp."StyleID"
      ) AS rn
    FROM
      "ENTERTAINMENTAGENCY"."ENTERTAINMENTAGENCY"."MUSICAL_PREFERENCES" mp
    WHERE mp."PreferenceSeq" IN (1, 2)
  ) mp
  GROUP BY mp."CustomerID"
  HAVING COUNT(*) >= 2
)
SELECT DISTINCT
  e."EntStageName",
  c."CustLastName"
FROM
  EntTopStyles ets
  INNER JOIN "ENTERTAINMENTAGENCY"."ENTERTAINMENTAGENCY"."ENTERTAINERS" e ON ets."EntertainerID" = e."EntertainerID"
  CROSS JOIN CustTopStyles cts
  INNER JOIN "ENTERTAINMENTAGENCY"."ENTERTAINMENTAGENCY"."CUSTOMERS" c ON cts."CustomerID" = c."CustomerID"
WHERE
  (
    (ets."EntStyleID1" = cts."CustStyleID1" AND ets."EntStyleID2" = cts."CustStyleID2")
    OR (ets."EntStyleID1" = cts."CustStyleID2" AND ets."EntStyleID2" = cts."CustStyleID1")
  );