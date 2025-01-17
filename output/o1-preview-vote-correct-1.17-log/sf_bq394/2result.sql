WITH temperature_averages AS (
    SELECT
        "year",
        "month",
        AVG("air_temperature") AS avg_air_temperature,
        AVG("wetbulb_temperature") AS avg_wetbulb_temperature,
        AVG("dewpoint_temperature") AS avg_dewpoint_temperature,
        AVG("sea_surface_temp") AS avg_sea_surface_temp
    FROM (
        SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2010"
        WHERE
            "year" BETWEEN 2010 AND 2014 AND
            "air_temperature" IS NOT NULL AND
            "wetbulb_temperature" IS NOT NULL AND
            "dewpoint_temperature" IS NOT NULL AND
            "sea_surface_temp" IS NOT NULL
        UNION ALL
        SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2011"
        WHERE
            "year" BETWEEN 2010 AND 2014 AND
            "air_temperature" IS NOT NULL AND
            "wetbulb_temperature" IS NOT NULL AND
            "dewpoint_temperature" IS NOT NULL AND
            "sea_surface_temp" IS NOT NULL
        UNION ALL
        SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2012"
        WHERE
            "year" BETWEEN 2010 AND 2014 AND
            "air_temperature" IS NOT NULL AND
            "wetbulb_temperature" IS NOT NULL AND
            "dewpoint_temperature" IS NOT NULL AND
            "sea_surface_temp" IS NOT NULL
        UNION ALL
        SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2013"
        WHERE
            "year" BETWEEN 2010 AND 2014 AND
            "air_temperature" IS NOT NULL AND
            "wetbulb_temperature" IS NOT NULL AND
            "dewpoint_temperature" IS NOT NULL AND
            "sea_surface_temp" IS NOT NULL
        UNION ALL
        SELECT "year", "month", "air_temperature", "wetbulb_temperature", "dewpoint_temperature", "sea_surface_temp"
        FROM "NOAA_DATA"."NOAA_ICOADS"."ICOADS_CORE_2014"
        WHERE
            "year" BETWEEN 2010 AND 2014 AND
            "air_temperature" IS NOT NULL AND
            "wetbulb_temperature" IS NOT NULL AND
            "dewpoint_temperature" IS NOT NULL AND
            "sea_surface_temp" IS NOT NULL
    )
    GROUP BY
        "year", "month"
)

SELECT
    "year",
    "month",
    ROUND(
        ABS(avg_air_temperature - avg_wetbulb_temperature) +
        ABS(avg_air_temperature - avg_dewpoint_temperature) +
        ABS(avg_air_temperature - avg_sea_surface_temp) +
        ABS(avg_wetbulb_temperature - avg_dewpoint_temperature) +
        ABS(avg_wetbulb_temperature - avg_sea_surface_temp) +
        ABS(avg_dewpoint_temperature - avg_sea_surface_temp),
        4
    ) AS sum_of_differences
FROM
    temperature_averages
ORDER BY
    sum_of_differences ASC NULLS LAST
LIMIT 3;