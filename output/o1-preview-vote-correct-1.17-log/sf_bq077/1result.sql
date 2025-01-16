WITH Motor_Thefts AS
(
    SELECT
        TO_TIMESTAMP_LTZ("date" / 1000000) AS "timestamp"
    FROM CHICAGO.CHICAGO_CRIME.CRIME
    WHERE "primary_type" = 'MOTOR VEHICLE THEFT'
        AND "date" IS NOT NULL
)
, Monthly_Counts AS
(
    SELECT
        EXTRACT(YEAR FROM "timestamp") AS "Year",
        EXTRACT(MONTH FROM "timestamp") AS "Month_Num",
        TO_CHAR("timestamp", 'Mon') AS "Month_Name",
        COUNT(*) AS "Motor_Theft_Count"
    FROM Motor_Thefts
    WHERE EXTRACT(YEAR FROM "timestamp") BETWEEN 2010 AND 2016
    GROUP BY
        EXTRACT(YEAR FROM "timestamp"),
        EXTRACT(MONTH FROM "timestamp"),
        TO_CHAR("timestamp", 'Mon')
)
SELECT
    "Year",
    "Month_Name" AS "Month",
    "Month_Num",
    "Motor_Theft_Count" AS "Highest_Motor_Thefts"
FROM
(
    SELECT
        "Year",
        "Month_Name",
        "Month_Num",
        "Motor_Theft_Count",
        ROW_NUMBER() OVER (PARTITION BY "Year" ORDER BY "Motor_Theft_Count" DESC NULLS LAST) AS rn
    FROM Monthly_Counts
)
WHERE rn = 1
ORDER BY "Year";