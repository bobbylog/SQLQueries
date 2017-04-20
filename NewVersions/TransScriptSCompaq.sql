

SELECT dbo.getstudentIDfromUID(SR1.StudentUID) AS StudentID, SR1.TermCalendarID, SR1.SROfferID, SR1.Department AS CourseDept, SR1.CourseID, SR1.Section, SR1.CourseName, SR1.Credits, SR1.Grade, 
               TC1.TermCalendarID AS ForTermID, TC1.Term as TermSeq, TC1.TextTerm AS ForTerm, MM1.MajorMinorName, TC1.ActiveFlag
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) AND (TC1.ActiveFlag = 1)
AND TC1.TextTerm not like '%bsn%'
AND SP1.MajorProgramID in (109 ,152,143)
AND SR1.StudentUID in
(SELECT DISTINCT 
               ST1.StudentUID
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'fa-16') AND (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) AND (TC1.ActiveFlag = 1)
-- AND (MM1.MajorMinorName LIKE '%nursing%') AND 
AND SP1.MajorProgramID in (109 ,152,143)
)