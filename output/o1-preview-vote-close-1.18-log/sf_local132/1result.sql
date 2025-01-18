WITH EntertainerTopStyles AS (
  SELECT 
    "EntertainerID",
    "StyleID"
  FROM (
    SELECT 
      "EntertainerID", 
      "StyleID", 
      "StyleStrength",
      DENSE_RANK() OVER (PARTITION BY "EntertainerID" ORDER BY "StyleStrength" DESC NULLS LAST) AS StyleRank
    FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."ENTERTAINER_STYLES"
  ) ets
  WHERE ets.StyleRank <= 2
),
CustomerTopPreferences AS (
  SELECT 
    "CustomerID",
    "StyleID"
  FROM (
    SELECT 
      "CustomerID",
      "StyleID",
      "PreferenceSeq",
      DENSE_RANK() OVER (PARTITION BY "CustomerID" ORDER BY "PreferenceSeq" ASC NULLS LAST) AS PrefRank
    FROM ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."MUSICAL_PREFERENCES"
  ) ctp
  WHERE ctp.PrefRank <= 2
),
EntertainerCustomerMatches AS (
  SELECT
    ets."EntertainerID",
    ctp."CustomerID"
  FROM EntertainerTopStyles ets
  JOIN CustomerTopPreferences ctp
    ON ets."StyleID" = ctp."StyleID"
  GROUP BY ets."EntertainerID", ctp."CustomerID"
  HAVING COUNT(*) = 2
)
SELECT
  e."EntStageName",
  c."CustLastName"
FROM EntertainerCustomerMatches ecm
JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."ENTERTAINERS" e
  ON ecm."EntertainerID" = e."EntertainerID"
JOIN ENTERTAINMENTAGENCY.ENTERTAINMENTAGENCY."CUSTOMERS" c
  ON ecm."CustomerID" = c."CustomerID";