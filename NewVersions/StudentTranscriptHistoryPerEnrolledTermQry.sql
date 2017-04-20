SELECT 'FA-16' as CurtermEnrolled, dbo.getStudentIDFromUID(SR1.StudentUID) AS StudentID, TC1.TextTerm AS ForTerm, SR1.CourseID, SR1.CourseName, ST1.LastName, ST1.FirstName, 
               ST1.MiddleInitial AS Middlename, SR1.Department AS CourseDept, SR1.Section, SR1.Grade, TC1.Term AS TermSeq, SR1.TermCalendarID, SR1.Credits, 
               TC1.TermCalendarID AS ForTermID, MM1.MajorMinorName, TC1.ActiveFlag
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) AND (TC1.ActiveFlag = 1) AND 
               (TC1.TextTerm NOT LIKE '%bsn%') AND (SP1.MajorProgramID IN (109, 152, 143)) AND (SR1.StudentUID IN
                   (SELECT DISTINCT ST1.StudentUID
                    FROM   dbo.SRAcademic AS SR1 LEFT OUTER JOIN
                                   dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
                                   dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
                                   dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
                                   dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
                                   dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
                                   dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
                    WHERE (TC1.TextTerm = 'fa-16') AND (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Credits > 0) AND 
                                   (TC1.ActiveFlag = 1) AND (SP1.MajorProgramID IN (109, 152, 143))))