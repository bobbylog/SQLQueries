SELECT GTA.*, CASE WHEN GTA.SLevel IS NULL THEN 'PP' ELSE GTA.SLevel END AS Svalue FROM
(
SELECT dbo.getStudentIDFromUID(SR1.StudentUID) AS StudentID, SR1.StudentUID, TC1.TextTerm AS ForTerm, SR1.CourseID, 
               SR1.Department + CAST(SR1.CourseID AS nvarchar(6)) + '-' + SR1.Section AS CourseDeptNum, SR1.CourseName, ST1.LastName, ST1.FirstName, 
               ST1.MiddleInitial AS Middlename, SR1.Department AS CourseDept, SR1.Section, SR1.Grade, TC1.Term AS TermSeq, SR1.TermCalendarID, SR1.Credits, 
               TC1.TermCalendarID AS ForTermID, MM1.MajorMinorName AS DegreeProgram, SP1.MajorProgramID, TC1.ActiveFlag,
               
                       
              ( select AB.Level from 
               
               (SELECT DISTINCT 
               SR1.StudentUID, TC1.textterm, SP1.MajorProgramID, 
               CASE SR1.CourseID WHEN '112' THEN 'S1' WHEN '122' THEN 'S2' WHEN '214' THEN 'S3' WHEN '222' THEN 'S4'  END AS LEVEL
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) 
               AND SR1.COURSEID IN ('112', '122', '214', '222') 
               AND 
               SR1.DEPARTMENT = 'NU') AB
               WHERE AB.StudentUID=SR1.StudentUID AND AB.MajorProgramID=SP1.MajorProgramID AND AB.TextTerm=TC1.TextTerm) 
               AS SLevel 
               
               
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) AND (TC1.TextTerm NOT LIKE '%bsn%') AND 
               (SP1.MajorProgramID IN (109, 152, 143)) AND (TC1.TextTerm IN
                   (SELECT TextTerm
                    FROM   dbo.TermCalendar
                    WHERE (YEAR(TermStartDate) >= YEAR(GETDATE()) - 5) AND (YEAR(TermStartDate) <= YEAR(GETDATE()))))
) GTA    
