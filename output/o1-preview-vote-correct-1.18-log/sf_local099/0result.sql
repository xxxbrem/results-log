SELECT COUNT(*) AS "Number_of_actors"
FROM (
  WITH
  Yash_Chopra_PID AS (
    SELECT "PID" AS "Director_PID"
    FROM DB_IMDB.DB_IMDB.PERSON
    WHERE "Name" = 'Yash Chopra'
  ),
  Yash_Chopra_Actor_Counts AS (
    SELECT c."PID" AS "Actor_PID", COUNT(DISTINCT c."MID") AS "Num_Movies_With_Yash_Chopra"
    FROM DB_IMDB.DB_IMDB.M_CAST c
    JOIN DB_IMDB.DB_IMDB.M_DIRECTOR d ON c."MID" = d."MID"
    JOIN Yash_Chopra_PID y ON d."PID" = y."Director_PID"
    GROUP BY c."PID"
  ),
  Actor_Director_Counts AS (
    SELECT c."PID" AS "Actor_PID", d."PID" AS "Director_PID", COUNT(DISTINCT c."MID") AS "Num_Movies"
    FROM DB_IMDB.DB_IMDB.M_CAST c
    JOIN DB_IMDB.DB_IMDB.M_DIRECTOR d ON c."MID" = d."MID"
    GROUP BY c."PID", d."PID"
  ),
  Max_Other_Director_Counts AS (
    SELECT "Actor_PID", MAX("Num_Movies") AS "Max_Num_Movies_Other_Director"
    FROM Actor_Director_Counts
    WHERE "Director_PID" <> (SELECT "Director_PID" FROM Yash_Chopra_PID)
    GROUP BY "Actor_PID"
  )
  SELECT y."Actor_PID"
  FROM Yash_Chopra_Actor_Counts y
  LEFT JOIN Max_Other_Director_Counts m ON y."Actor_PID" = m."Actor_PID"
  WHERE y."Num_Movies_With_Yash_Chopra" > COALESCE(m."Max_Num_Movies_Other_Director", 0)
)