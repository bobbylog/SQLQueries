SELECT DISTINCT 
               TOP (100) PERCENT TC1.TextTerm AS Term, ST1.StudentUID, ST1.StudentID, LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) 
               AS FirstName, ST1.MiddleInitial, MM1.MajorMinorName AS DegreeProgram, LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) 
               AS USERID, dbo.getStudentEmailAddressFromID(ST1.StudentID) as Email1,  dbo.isNewStudentByTerm(st1.StudentID,'sp-18') as NewS1 
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'Sp-18') 
--AND (NOT (GL1.DisplayText = 'Transfer')) 
AND (NOT (ST1.LastName = 'Testperson'))
and MM1.MajorMinorName like 'Nursing'
AND NOT SR1.grade='W'

ORDER BY LastName, FirstName