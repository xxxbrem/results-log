WITH data AS (
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2010"
    WHERE "air_temperature" IS NOT NULL AND "wetbulb_temperature" IS NOT NULL AND "dewpoint_temperature" IS NOT NULL AND "sea_surface_temp" IS NOT NULL
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2011"
    WHERE "air_temperature" IS NOT NULL AND "wetbulb_temperature" IS NOT NULL AND "dewpoint_temperature" IS NOT NULL AND "sea_surface_temp" IS NOT NULL
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2012"
    WHERE "air_temperature" IS NOT NULL AND "wetbulb_temperature" IS NOT NULL AND "dewpoint_temperature" IS NOT NULL AND "sea_surface_temp" IS NOT NULL
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2013"
    WHERE "air_temperature" IS NOT NULL AND "wetbulb_temperature" IS NOT NULL AND "dewpoint_temperature" IS NOT NULL AND "sea_surface_temp" IS NOT NULL
    UNION ALL
    SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
    FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2014"
    WHERE "air_temperature" IS NOT NULL AND "wetbulb_temperature" IS NOT NULL AND "dewpoint_temperature" IS NOT NULL AND "sea_surface_temp" IS NOT NULL
)
SELECT "year", "month",
    ROUND(
        ABS(avg_air - avg_wetbulb) + 
        ABS(avg_air - avg_dewpoint) + 
        ABS(avg_air - avg_sst) + 
        ABS(avg_wetbulb - avg_dewpoint) + 
        ABS(avg_wetbulb - avg_sst) + 
        ABS(avg_dewpoint - avg_sst)
        , 4) AS "Sum_of_Differences"
FROM (
    SELECT "year", "month",
        AVG("air_temperature") AS avg_air,
        AVG("wetbulb_temperature") AS avg_wetbulb,
        AVG("dewpoint_temperature") AS avg_dewpoint,
        AVG("sea_surface_temp") AS avg_sst
    FROM data
    GROUP BY "year", "month"
) sub
ORDER BY "Sum_of_Differences" ASC NULLS LAST, "year", "month"
LIMIT 3;