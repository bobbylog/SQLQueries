SELECT DISTINCT 
               TOP (100) PERCENT TC1.TextTerm AS Term, ST1.StudentUID, ST1.StudentID, LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) 
               AS FirstName, ST1.MiddleInitial, MM1.MajorMinorName AS DegreeProgram, dbo.CAMS_StudentAddressList_View.Email1
FROM  dbo.Student AS ST1 LEFT OUTER JOIN
               dbo.CAMS_StudentAddressList_View ON ST1.StudentUID = dbo.CAMS_StudentAddressList_View.StudentUID RIGHT OUTER JOIN
               dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId ON ST1.StudentUID = SR1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'fa-17') AND (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson'))
ORDER BY LastName, FirstName