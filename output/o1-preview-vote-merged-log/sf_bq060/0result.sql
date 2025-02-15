SELECT c."country_name", b."net_migration"
FROM CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.COUNTRY_NAMES_AREA c
JOIN CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL.BIRTH_DEATH_GROWTH_RATES b
ON c."country_code" = b."country_code"
WHERE b."year" = 2017 AND c."country_area" > 500
ORDER BY b."net_migration" DESC NULLS LAST
LIMIT 3;