declare @CTerm varchar(12)
declare @NTerm varchar(12)
declare @Tday datetime
declare @t int

set @CTerm=dbo.getCurrentTerm()
set @NTerm=dbo.getNextCurrentTerm()
set @Tday=GETDATE()
set @t=dbo.getTermID(@CTerm)

IF CHARINDEX('SU', @CTerm) >0 
BEGIN

--drop table dbo.tmpStudentStatHistory

INSERT INTO dbo.tmpStudentStatHistory
SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, GETDATE() as SDATE,
		dbo.isStudentGraduated(dbo.StudentStatus.StudentUID, @t)
-- INTO dbo.tmpStudentStatHistory
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @Nterm) AND (dbo.StudentStatus.StudentUID IN
                   (SELECT StudentStatus_1.StudentUID
                    FROM   dbo.TermCalendar AS TermCalendar_1 INNER JOIN
                                   dbo.StudentStatus AS StudentStatus_1 ON TermCalendar_1.TermCalendarID = StudentStatus_1.TermCalendarID INNER JOIN
                                   dbo.EnrollmentStatus AS EnrollmentStatus_1 ON StudentStatus_1.EnrollmentStatusID = EnrollmentStatus_1.EnrollmentStatusID
                    WHERE (TermCalendar_1.ActiveFlag = 'True') AND (TermCalendar_1.TextTerm = @CTerm)))
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>2 -- Continuing
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>27 -- Transfer
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>1 -- Alumni
                    AND dbo.EnrollmentStatus.Status NOT LIKE '%Freshman%'
                  
                      
                    -- AND dbo.StudentStatus.StudentUID IN (46134, 54210, 56295, 60092, 60536)
                    -- AND dbo.StudentStatus.StudentUID IN (54210)
					  
					 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					 ( SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
					 AND EnrollmentStatusID <> 2 
 					 
 					-- UPDATE dbo.StudentStatus set EnrollmentStatusID=1 WHERE StudentStatusID IN 
					 --( SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=1)
					 --AND EnrollmentStatusID <> 1 
 
					EXEC msdb.dbo.sp_send_dbmail 
						@profile_name='TROCMAIL',
						@recipients = 'etiennes@trocaire.edu;BagwellD@Trocaire.edu', 
						@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
						@subject = 'Student Status Change Report',
						@body = 'IDs of Students whose Status have changed to CONTINUING today:' ;  

 
  
END
ELSE
BEGIN

INSERT INTO dbo.tmpStudentStatHistory
SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, GETDATE() as SDATE, 
        dbo.isStudentGraduated(dbo.StudentStatus.StudentUID,@t )
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = @Nterm) AND (dbo.StudentStatus.StudentUID IN
                   (SELECT StudentStatus_1.StudentUID
                    FROM   dbo.TermCalendar AS TermCalendar_1 INNER JOIN
                                   dbo.StudentStatus AS StudentStatus_1 ON TermCalendar_1.TermCalendarID = StudentStatus_1.TermCalendarID INNER JOIN
                                   dbo.EnrollmentStatus AS EnrollmentStatus_1 ON StudentStatus_1.EnrollmentStatusID = EnrollmentStatus_1.EnrollmentStatusID
                    WHERE (TermCalendar_1.ActiveFlag = 'True') AND (TermCalendar_1.TextTerm = @CTerm)))
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>2 -- Continuing
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>27 -- Transfer
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>1 -- Alumni
                    -- AND dbo.EnrollmentStatus.Status NOT LIKE '%Freshman%'
         
					 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					 ( SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
					 AND EnrollmentStatusID <> 2 
					 
					 --UPDATE dbo.StudentStatus set EnrollmentStatusID=1 WHERE StudentStatusID IN 
					 --( SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=1)
					 --AND EnrollmentStatusID <> 1 
 
					EXEC msdb.dbo.sp_send_dbmail 
						@profile_name='TROCMAIL',
						@recipients = 'etiennes@trocaire.edu;BagwellD@Trocaire.edu', 
						@query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
						@subject = 'Student Status Change Report',
						@body = 'IDs of Students whose Status have changed to CONTINUING today:' ;           
         
           
 -- UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
 --(SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday))
 --AND EnrollmentStatusID <> 2       

END  