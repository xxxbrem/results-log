SELECT s."name", SUM(g."count_temp") AS "Number_of_Valid_Temperature_Observations"
FROM (
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2011
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2012
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2013
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2014
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2015
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2016
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2017
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2018
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2019
  UNION ALL
  SELECT "stn", "wban", "count_temp" FROM NEW_YORK_NOAA.NOAA_GSOD.GSOD2020
) g
JOIN NEW_YORK_NOAA.NOAA_GSOD.STATIONS s
  ON s."usaf" = g."stn" AND s."wban" = g."wban"
WHERE ST_DWITHIN(
    ST_MAKEPOINT(TRY_TO_DOUBLE(s."lon"), TRY_TO_DOUBLE(s."lat")),
    ST_MAKEPOINT(-73.764, 41.197),
    32186.9  -- 20 miles in meters
)
GROUP BY s."name";