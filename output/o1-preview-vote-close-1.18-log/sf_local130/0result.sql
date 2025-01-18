WITH english_students AS (
    SELECT st."StudLastName", ss."Grade"
    FROM SCHOOL_SCHEDULING.SCHOOL_SCHEDULING.STUDENTS st
    JOIN SCHOOL_SCHEDULING.SCHOOL_SCHEDULING.STUDENT_SCHEDULES ss ON st."StudentID" = ss."StudentID"
    JOIN SCHOOL_SCHEDULING.SCHOOL_SCHEDULING.CLASSES c ON ss."ClassID" = c."ClassID"
    JOIN SCHOOL_SCHEDULING.SCHOOL_SCHEDULING.SUBJECTS s ON c."SubjectID" = s."SubjectID"
    WHERE s."SubjectName" ILIKE '%Composition%'
      AND ss."ClassStatus" = (
          SELECT "ClassStatus"
          FROM SCHOOL_SCHEDULING.SCHOOL_SCHEDULING.STUDENT_CLASS_STATUS
          WHERE "ClassStatusDescription" = 'Completed'
      )
      AND ss."Grade" IS NOT NULL
),
graded_students AS (
    SELECT "StudLastName", "Grade",
           NTILE(5) OVER (ORDER BY "Grade" DESC NULLS LAST) AS "QuintileRank"
    FROM english_students
)
SELECT DISTINCT "StudLastName", "QuintileRank"
FROM graded_students
ORDER BY "QuintileRank" DESC NULLS LAST;