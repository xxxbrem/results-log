SELECT b."country_name", b."net_migration"
FROM CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.BIRTH_DEATH_GROWTH_RATES b
JOIN CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.COUNTRY_NAMES_AREA c
ON b."country_code" = c."country_code"
WHERE b."year" = 2017 AND c."country_area" > 500
ORDER BY b."net_migration" DESC NULLS LAST
LIMIT 3;