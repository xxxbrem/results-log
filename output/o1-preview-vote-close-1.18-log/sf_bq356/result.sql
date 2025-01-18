WITH station_info AS (
    SELECT S."usaf", S."wban"
    FROM NOAA_DATA.NOAA_GSOD.STATIONS AS S
    WHERE TRY_TO_DATE(S."begin", 'YYYYMMDD') <= '20000101' AND TRY_TO_DATE(S."end", 'YYYYMMDD') >= '20190630'
),
all_years_data AS (
    SELECT "stn", "wban", "year", COUNT(*) AS "valid_days"
    FROM (
        SELECT G2000."stn", G2000."wban", G2000."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2000 AS G2000
        WHERE G2000."count_temp" > 0
        UNION ALL
        SELECT G2001."stn", G2001."wban", G2001."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2001 AS G2001
        WHERE G2001."count_temp" > 0
        UNION ALL
        SELECT G2002."stn", G2002."wban", G2002."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2002 AS G2002
        WHERE G2002."count_temp" > 0
        UNION ALL
        SELECT G2003."stn", G2003."wban", G2003."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2003 AS G2003
        WHERE G2003."count_temp" > 0
        UNION ALL
        SELECT G2004."stn", G2004."wban", G2004."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2004 AS G2004
        WHERE G2004."count_temp" > 0
        UNION ALL
        SELECT G2005."stn", G2005."wban", G2005."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2005 AS G2005
        WHERE G2005."count_temp" > 0
        UNION ALL
        SELECT G2006."stn", G2006."wban", G2006."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2006 AS G2006
        WHERE G2006."count_temp" > 0
        UNION ALL
        SELECT G2007."stn", G2007."wban", G2007."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2007 AS G2007
        WHERE G2007."count_temp" > 0
        UNION ALL
        SELECT G2008."stn", G2008."wban", G2008."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2008 AS G2008
        WHERE G2008."count_temp" > 0
        UNION ALL
        SELECT G2009."stn", G2009."wban", G2009."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2009 AS G2009
        WHERE G2009."count_temp" > 0
        UNION ALL
        SELECT G2010."stn", G2010."wban", G2010."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2010 AS G2010
        WHERE G2010."count_temp" > 0
        UNION ALL
        SELECT G2011."stn", G2011."wban", G2011."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2011 AS G2011
        WHERE G2011."count_temp" > 0
        UNION ALL
        SELECT G2012."stn", G2012."wban", G2012."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2012 AS G2012
        WHERE G2012."count_temp" > 0
        UNION ALL
        SELECT G2013."stn", G2013."wban", G2013."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2013 AS G2013
        WHERE G2013."count_temp" > 0
        UNION ALL
        SELECT G2014."stn", G2014."wban", G2014."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2014 AS G2014
        WHERE G2014."count_temp" > 0
        UNION ALL
        SELECT G2015."stn", G2015."wban", G2015."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2015 AS G2015
        WHERE G2015."count_temp" > 0
        UNION ALL
        SELECT G2016."stn", G2016."wban", G2016."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2016 AS G2016
        WHERE G2016."count_temp" > 0
        UNION ALL
        SELECT G2017."stn", G2017."wban", G2017."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2017 AS G2017
        WHERE G2017."count_temp" > 0
        UNION ALL
        SELECT G2018."stn", G2018."wban", G2018."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2018 AS G2018
        WHERE G2018."count_temp" > 0
        UNION ALL
        SELECT G2019."stn", G2019."wban", G2019."year"
        FROM NOAA_DATA.NOAA_GSOD.GSOD2019 AS G2019
        WHERE G2019."count_temp" > 0
    ) AS combined_data
    GROUP BY "stn", "wban", "year"
),
max_valid_days AS (
    SELECT "stn", "wban", MAX("valid_days") AS "max_valid_days"
    FROM all_years_data
    GROUP BY "stn", "wban"
),
valid_days_2019 AS (
    SELECT "stn", "wban", "valid_days" AS "valid_days_2019"
    FROM all_years_data
    WHERE "year" = 2019
),
final_data AS (
    SELECT s."usaf", s."wban", m."max_valid_days", v."valid_days_2019"
    FROM station_info s
    JOIN max_valid_days m
        ON s."usaf" = m."stn" AND s."wban" = m."wban"
    JOIN valid_days_2019 v
        ON s."usaf" = v."stn" AND s."wban" = v."wban"
)
SELECT COUNT(*) AS "Number_of_weather_stations"
FROM final_data
WHERE "valid_days_2019" >= 0.9 * "max_valid_days";