WITH monthly_thefts AS (
    SELECT
        "year",
        EXTRACT(MONTH FROM TO_TIMESTAMP_NTZ("date" / 1e6)) AS "month_num",
        COUNT(*) AS "number_of_motor_thefts"
    FROM
        CHICAGO.CHICAGO_CRIME.CRIME
    WHERE
        "primary_type" = 'MOTOR VEHICLE THEFT'
        AND "year" BETWEEN 2010 AND 2016
    GROUP BY
        "year", "month_num"
)
SELECT
    "year",
    "month_num",
    TRIM(TO_CHAR(DATE_FROM_PARTS(2000, "month_num", 1), 'Month')) AS "month_name",
    "number_of_motor_thefts"
FROM
    (
        SELECT
            monthly_thefts.*,
            ROW_NUMBER() OVER (PARTITION BY "year" ORDER BY "number_of_motor_thefts" DESC NULLS LAST) AS rn
        FROM monthly_thefts
    )
WHERE
    rn = 1
ORDER BY
    "year";