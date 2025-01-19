SELECT CONCAT(year, '-', LPAD(mo, 2, '0'), '-', LPAD(da, 2, '0')) AS Date
FROM `bigquery-public-data.noaa_gsod.gsod2009`
WHERE stn = '723758' AND year = '2009' AND mo = '10' AND temp != 9999.9
ORDER BY temp DESC
LIMIT 3;