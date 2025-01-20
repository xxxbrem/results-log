WITH unioned_data AS (
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2010"
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2011"
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2012"
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2013"
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2014"
),
monthly_averages AS (
    SELECT
        "year",
        "month",
        ROUND(AVG("air_temperature"), 4) AS avg_air_temp,
        ROUND(AVG("wetbulb_temperature"), 4) AS avg_wetbulb_temp,
        ROUND(AVG("dewpoint_temperature"), 4) AS avg_dewpoint_temp,
        ROUND(AVG("sea_surface_temp"), 4) AS avg_sea_surface_temp
    FROM unioned_data
    WHERE "year" BETWEEN 2010 AND 2014
    GROUP BY "year", "month"
    HAVING
        COUNT("air_temperature") > 0 AND
        COUNT("wetbulb_temperature") > 0 AND
        COUNT("dewpoint_temperature") > 0 AND
        COUNT("sea_surface_temp") > 0
)
SELECT
    "year" AS "Year",
    "month" AS "Month",
    ROUND(
        ABS(avg_air_temp - avg_wetbulb_temp) +
        ABS(avg_air_temp - avg_dewpoint_temp) +
        ABS(avg_air_temp - avg_sea_surface_temp) +
        ABS(avg_wetbulb_temp - avg_dewpoint_temp) +
        ABS(avg_wetbulb_temp - avg_sea_surface_temp) +
        ABS(avg_dewpoint_temp - avg_sea_surface_temp),
        4
    ) AS "Sum_of_Differences"
FROM monthly_averages
ORDER BY "Sum_of_Differences" ASC NULLS LAST
LIMIT 3;