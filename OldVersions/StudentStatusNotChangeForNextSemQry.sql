declare @CTerm varchar(12)
declare @NTerm varchar(12)

set @CTerm=dbo.getCurrentTerm()
set @NTerm=dbo.getNextCurrentTerm()

IF CHARINDEX('SU', @CTerm) >0
BEGIN

SELECT dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @Cterm) AND (dbo.StudentStatus.StudentUID IN
                   (SELECT StudentStatus_1.StudentUID
                    FROM   dbo.TermCalendar AS TermCalendar_1 INNER JOIN
                                   dbo.StudentStatus AS StudentStatus_1 ON TermCalendar_1.TermCalendarID = StudentStatus_1.TermCalendarID INNER JOIN
                                   dbo.EnrollmentStatus AS EnrollmentStatus_1 ON StudentStatus_1.EnrollmentStatusID = EnrollmentStatus_1.EnrollmentStatusID
                    WHERE (TermCalendar_1.ActiveFlag = 'True') AND (TermCalendar_1.TextTerm = @NTerm)))
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>2
                    AND dbo.EnrollmentStatus.Status NOT LIKE '%Freshman%'

END
                    