WITH t_pubs AS (
  SELECT "publication_number", "filing_date", "grant_date"
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS
  WHERE "country_code" = 'US' AND "kind_code" = 'B2' AND "grant_date" BETWEEN 20100101 AND 20141231
),
t_pubs_with_citations AS (
  SELECT t_pubs."publication_number" AS focal_pub_num, t_pubs."filing_date" AS focal_filing_date, t_pubs."grant_date", t_abs."cited_by"
  FROM t_pubs
  JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t_abs
    ON t_pubs."publication_number" = t_abs."publication_number"
  WHERE t_abs."cited_by" IS NOT NULL
),
t_citations AS (
  SELECT t_pubs_with_citations.focal_pub_num, t_pubs_with_citations.focal_filing_date, t_pubs_with_citations."grant_date",
         citing_pub_num.value:"publication_number"::STRING AS citing_pub_num
  FROM t_pubs_with_citations,
       LATERAL FLATTEN(input => t_pubs_with_citations."cited_by") citing_pub_num
),
t_citations_with_dates AS (
  SELECT t_citations.focal_pub_num, t_citations.focal_filing_date, t_citations."grant_date", t_citations.citing_pub_num,
         t_citing_pubs."filing_date" AS citing_filing_date
  FROM t_citations
  JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS t_citing_pubs
    ON t_citations.citing_pub_num = t_citing_pubs."publication_number"
  WHERE t_citing_pubs."filing_date" IS NOT NULL
),
t_citations_within_month AS (
  SELECT t_cwd.focal_pub_num, t_cwd.focal_filing_date, t_cwd."grant_date", t_cwd.citing_pub_num
  FROM t_citations_with_dates t_cwd
  WHERE DATEDIFF('day', TO_DATE(t_cwd.focal_filing_date::VARCHAR, 'YYYYMMDD'), TO_DATE(t_cwd.citing_filing_date::VARCHAR, 'YYYYMMDD')) BETWEEN 0 AND 30
),
t_forward_citations_count AS (
  SELECT focal_pub_num, focal_filing_date, "grant_date", COUNT(*) AS number_of_forward_citations_within_a_month
  FROM t_citations_within_month
  GROUP BY focal_pub_num, focal_filing_date, "grant_date"
),
t_max_citation AS (
  SELECT focal_pub_num, focal_filing_date, "grant_date", number_of_forward_citations_within_a_month
  FROM t_forward_citations_count
  ORDER BY number_of_forward_citations_within_a_month DESC NULLS LAST
  LIMIT 1
),
t_focal_info AS (
  SELECT t_max_citation.focal_pub_num, t_max_citation.focal_filing_date, t_max_citation."grant_date",
         t_max_citation.number_of_forward_citations_within_a_month,
         SUBSTR(t_max_citation.focal_filing_date::VARCHAR,1,4) AS focal_filing_year
  FROM t_max_citation
),
t_focal_emb AS (
  SELECT t_abs."publication_number", t_abs."embedding_v1" AS emb_focal
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t_abs
  WHERE t_abs."publication_number" = (SELECT focal_pub_num FROM t_focal_info) AND t_abs."embedding_v1" IS NOT NULL
),
t_focal_emb_flat AS (
  SELECT emb_focal_i.seq, emb_focal_i.value::FLOAT AS emb_focal_value
  FROM t_focal_emb,
       LATERAL FLATTEN(input => t_focal_emb.emb_focal) AS emb_focal_i
),
t_same_year_pubs AS (
  SELECT t_pub."publication_number", t_pub."filing_date", t_abs."embedding_v1" AS emb_other
  FROM PATENTS_GOOGLE.PATENTS_GOOGLE.PUBLICATIONS t_pub
  JOIN PATENTS_GOOGLE.PATENTS_GOOGLE.ABS_AND_EMB t_abs
    ON t_pub."publication_number" = t_abs."publication_number"
  WHERE t_pub."filing_date" IS NOT NULL
    AND SUBSTR(t_pub."filing_date"::VARCHAR,1,4) = (SELECT focal_filing_year FROM t_focal_info)
    AND t_pub."publication_number" != (SELECT focal_pub_num FROM t_focal_info)
    AND t_abs."embedding_v1" IS NOT NULL
),
t_similarity AS (
  SELECT t_syp."publication_number" AS similar_patent_publication_number,
         SUM(t_focal_emb_flat.emb_focal_value * emb_other_i.value::FLOAT) AS similarity_score
  FROM t_same_year_pubs t_syp,
       LATERAL FLATTEN(input => t_syp.emb_other) emb_other_i
  JOIN t_focal_emb_flat
    ON emb_other_i.SEQ = t_focal_emb_flat.seq
  GROUP BY t_syp."publication_number"
),
t_most_similar AS (
  SELECT similar_patent_publication_number, similarity_score
  FROM t_similarity
  ORDER BY similarity_score DESC NULLS LAST
  LIMIT 1
)
SELECT t_focal_info.focal_pub_num AS publication_number,
       TO_DATE(t_focal_info.focal_filing_date::VARCHAR, 'YYYYMMDD') AS filing_date,
       TO_DATE(t_focal_info."grant_date"::VARCHAR, 'YYYYMMDD') AS grant_date,
       t_focal_info.number_of_forward_citations_within_a_month,
       t_most_similar.similar_patent_publication_number,
       ROUND(t_most_similar.similarity_score, 4) AS similarity_score
FROM t_focal_info CROSS JOIN t_most_similar;