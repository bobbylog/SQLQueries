SELECT dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = 'FA-16') AND (dbo.StudentStatus.StudentUID IN
                   (SELECT StudentStatus_1.StudentUID
                    FROM   dbo.TermCalendar AS TermCalendar_1 INNER JOIN
                                   dbo.StudentStatus AS StudentStatus_1 ON TermCalendar_1.TermCalendarID = StudentStatus_1.TermCalendarID INNER JOIN
                                   dbo.EnrollmentStatus AS EnrollmentStatus_1 ON StudentStatus_1.EnrollmentStatusID = EnrollmentStatus_1.EnrollmentStatusID
                    WHERE (TermCalendar_1.ActiveFlag = 'True') AND (TermCalendar_1.TextTerm = 'Su-16')))