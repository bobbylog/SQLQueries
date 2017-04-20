select T1.* from (
SELECT TOP (100) PERCENT ST1.StudentUID, ST1.StudentID, ST1.LastName, ST1.FirstName, dbo.StudentStatus.StatEffectiveDate, SR1.CourseName
FROM  dbo.StudentStatus INNER JOIN
               dbo.Student AS ST1 ON dbo.StudentStatus.StudentUID = ST1.StudentUID RIGHT OUTER JOIN
               dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId ON ST1.StudentUID = SR1.StudentUID
WHERE (TC1.TextTerm = 'FA-16') AND (GL1.DisplayText = 'Curriculum') AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Department IN ('OR', 'OS', 'OT')) OR
               (TC1.TextTerm = 'FA-16') AND (GL1.DisplayText = 'Curriculum') AND (NOT (ST1.LastName = 'Testperson')) AND (SR1.Department = 'BSN') AND (SR1.CourseID = '100')


) T1
where YEAR(T1.StatEffectiveDate)=2016
and MONTH(T1.StatEffectiveDate)=06
and day(T1.StatEffectiveDate) between 01 AND 10

ORDER BY T1.LastName