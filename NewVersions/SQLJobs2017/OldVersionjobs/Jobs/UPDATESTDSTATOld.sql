USE [msdb]
GO

/****** Object:  Job [UPDATESTDSTAT]    Script Date: 03/28/2017 17:02:06 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 03/28/2017 17:02:06 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'UPDATESTDSTAT', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Routine that updates student status regularly.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\etiennes', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [UpdatesTOCnt]    Script Date: 03/28/2017 17:02:06 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'UpdatesTOCnt', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @CTerm varchar(12)
declare @NTerm varchar(12)
declare @Tday datetime
declare @t int

set @CTerm=dbo.getCurrentTerm()
set @NTerm=dbo.getNextCurrentTerm()
set @Tday=GETDATE()
set @t=dbo.getTermID(@CTerm)



IF CHARINDEX(''SU'', @CTerm) >0 
BEGIN
-- Current Term

SELECT  dbo.studentstatus.StudentStatusID,  dbo.StudentStatus.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
INTO #TBCurActive
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID INNER JOIN
               dbo.Student ON dbo.StudentStatus.StudentUID = dbo.Student.StudentUID

WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm = @CTerm) and dbo.StudentStatus.StudentUID in
(
	   SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
) 

-- Next Term
SELECT  dbo.studentstatus.StudentStatusID,  dbo.StudentStatus.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
INTO #TBNextActive
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
               dbo.Student ON dbo.StudentStatus.StudentUID = dbo.Student.StudentUID
WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm = @NTerm) and dbo.StudentStatus.StudentUID in
(
		SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@NTerm))
)

-- Display result
	-- delete from dbo.tmpStudentStatHistory
	INSERT INTO dbo.tmpStudentStatHistory
	select *, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
	-- INTO dbo.tmpStudentStatHistory
	from #TBNextActive where StudentUID in (
	select distinct StudentUID from #TBCurActive)
	  AND EnrollmentStatusID <>2 -- Continuing
	  AND EnrollmentStatusID <>27 -- Transfer
	  -- AND EnrollmentStatusID <>1 -- Alumni
	  AND Status NOT LIKE ''%Freshman%''
  
   UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
	AND EnrollmentStatusID <> 2 
 	
 	EXEC msdb.dbo.sp_send_dbmail 
		@profile_name=''TROCMAIL'',
		@recipients = ''etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu'', 
		@query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
		@subject = ''Student Status Change Report'',
		@body = ''IDs of Students whose Status have changed to CONTINUING today:'' ;  
  
  drop table #TBCurActive
  drop table #TBNextActive
  
  END
 ELSE
 BEGIN
		 
		SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
		INTO #TBCurActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
					   dbo.Student ON dbo.StudentStatus.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm = @CTerm)and dbo.StudentStatus.StudentUID in
		(
				
		SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@CTerm))
		
		) 

		-- Next Term
		SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
		INTO #TBNextActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID INNER JOIN
					   dbo.Student ON dbo.StudentStatus.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm = @NTerm)and dbo.StudentStatus.StudentUID in
		(
		
		
		SELECT DISTINCT
					CAMS_RptStudentAddressList_View.StudentUID
		FROM  dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View INNER JOIN
               dbo.Student ON CAMS_RptStudentAddressList_View.StudentUID = dbo.Student.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = dbo.Student.StudentID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON CAMS_RptStudentAddressList_View.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               CAMS_RptStudentAddressList_View.StudentID = CAMS_RptRoster_View.StudentID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID AND 
               CAMS_RptRoster_View.TermCalendarID = CAMS_RptSROfferType1000_View.SemesterID
		WHERE (CAMS_RptSROfferType1000_View.TextTerm IN (@NTerm))
		
		)

		-- Display result
			-- delete from dbo.tmpStudentStatHistory
			INSERT INTO dbo.tmpStudentStatHistory
			select *, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
			-- INTO dbo.tmpStudentStatHistory
			from #TBNextActive1 where StudentUID in (
			select distinct StudentUID from #TBCurActive1)
			  AND EnrollmentStatusID <>2 -- Continuing
			  AND EnrollmentStatusID <>27 -- Transfer
			 -- AND EnrollmentStatusID <>1 -- Alumni
			  -- AND Status NOT LIKE ''%Freshman%''
		  
		   UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
		   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
			AND EnrollmentStatusID <> 2 
		 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name=''TROCMAIL'',
				@recipients = ''etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu'', 
				@query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
				@subject = ''Student Status Change Report'',
				@body = ''IDs of Students whose Status have changed to CONTINUING this week:'' ;  
		  
		  drop table #TBCurActive1
		  drop table #TBNextActive1
  
  END
  
  
  
  

  
', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'STATSCHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=32, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20160630, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, 
		@schedule_uid=N'f845a292-4582-4ca6-bc77-2c98fff075aa'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


