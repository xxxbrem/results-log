SELECT 
    B."country_name", 
    TO_CHAR(B."net_migration", 'FM90.0000') AS "Net_Migration_Rate"
FROM 
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."BIRTH_DEATH_GROWTH_RATES" B
JOIN 
    CENSUS_BUREAU_INTERNATIONAL.CENSUS_BUREAU_INTERNATIONAL."COUNTRY_NAMES_AREA" C
ON 
    B."country_code" = C."country_code"
WHERE 
    B."year" = 2017 
    AND C."country_area" > 500
ORDER BY 
    B."net_migration" DESC NULLS LAST
LIMIT 3;