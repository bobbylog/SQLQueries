SELECT dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = 'FA-16')