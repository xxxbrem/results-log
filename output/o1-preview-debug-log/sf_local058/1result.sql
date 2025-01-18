WITH counts_2020 AS (
    SELECT
        hdp."segment" AS "Hardware_Product_Segment",
        COUNT(DISTINCT hfs."product_code") AS "Unique_Product_Count_2020"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" hfs
    JOIN
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" hdp
    ON
        hfs."product_code" = hdp."product_code"
    WHERE
        hfs."fiscal_year" = 2020
    GROUP BY
        hdp."segment"
),
counts_2021 AS (
    SELECT
        hdp."segment" AS "Hardware_Product_Segment",
        COUNT(DISTINCT hfs."product_code") AS "Unique_Product_Count_2021"
    FROM
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_FACT_SALES_MONTHLY" hfs
    JOIN
        "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT" hdp
    ON
        hfs."product_code" = hdp."product_code"
    WHERE
        hfs."fiscal_year" = 2021
    GROUP BY
        hdp."segment"
),
all_segments AS (
    SELECT DISTINCT "segment" AS "Hardware_Product_Segment"
    FROM "EDUCATION_BUSINESS"."EDUCATION_BUSINESS"."HARDWARE_DIM_PRODUCT"
)
SELECT
    all_seg."Hardware_Product_Segment",
    COALESCE(c2020."Unique_Product_Count_2020", 0) AS "Unique_Product_Count_2020",
    COALESCE(c2021."Unique_Product_Count_2021", 0) AS "Unique_Product_Count_2021",
    CASE 
        WHEN COALESCE(c2020."Unique_Product_Count_2020", 0) = 0 THEN NULL
        ELSE ROUND(
            ((COALESCE(c2021."Unique_Product_Count_2021", 0) - COALESCE(c2020."Unique_Product_Count_2020", 0))
            / COALESCE(c2020."Unique_Product_Count_2020", 0)::float) * 100, 4)
    END AS "Percentage_Increase"
FROM
    all_segments all_seg
LEFT JOIN
    counts_2020 c2020
ON
    all_seg."Hardware_Product_Segment" = c2020."Hardware_Product_Segment"
LEFT JOIN
    counts_2021 c2021
ON
    all_seg."Hardware_Product_Segment" = c2021."Hardware_Product_Segment"
ORDER BY
    "Percentage_Increase" DESC NULLS LAST;