USE [msdb]
GO

/****** Object:  Job [UPDATESTDSTAT]    Script Date: 05/12/2017 14:23:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:23:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'UPDATESTDSTAT', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Routine that updates student status regularly.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\etiennes', 
		@notify_email_operator_name=N'System Admin', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [UpdatesTOCnt]    Script Date: 05/12/2017 14:23:38 ******/
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
		@command=N'--drop table #TBNextActive1
--drop table #TBCurActive2
--drop table #TBCurActive1

declare @CTerm varchar(12)
declare @NTerm varchar(12)
declare @Tday datetime
declare @t int

set @CTerm=dbo.getCurrentTerm()
set @NTerm=dbo.getNextCurrentTerm()
set @Tday=GETDATE()
set @t=dbo.getTermID(@CTerm)



IF CHARINDEX(''SU'', @CTerm) >0 
 BEGIN
		-- List of Student Registered in Current Term
		SELECT  dbo.CAMS_StudentStatus_View.StudentStatusID, dbo.CAMS_StudentStatus_View.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, dbo.CAMS_StudentStatus_View.TermCalendarID as CurrentTerm, 
		dbo.getStudentNextEnrolledTerm(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrTerm,
		dbo.getStudentNextEnrolledStatusID(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrStatusID
	    INTO #TBCurActive1
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.CAMS_StudentStatus_View ON dbo.TermCalendar.TermCalendarID = dbo.CAMS_StudentStatus_View.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.CAMS_StudentStatus_View.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
					   dbo.Student ON dbo.CAMS_StudentStatus_View.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm =@CTerm)and dbo.CAMS_StudentStatus_View.StudentUID in
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

		-- List of students who have enrollment in other term whose status is not continuing or transfer
		select * 
		into #TBCurActive2
		from #TBCurActive1 
		where 
		NEnrTerm <>0
		and EnrollmentStatusID<>2 
		--and EnrollmentStatusID<>27
		and EnrollmentStatusId <>3


		--select * from #TBCurActive2

		-- List of students status  enrolled in other term whose status is not continuing or transfer
		select StudentStatusID,StudentUID,StudentID, EnrollmentStatus as Status, EnrollmentStatusID, StudentLoad
		into #TBNextActive1
		from dbo.CAMS_StudentStatus_View
		where StudentLoad <>'''' 
		and EnrollmentStatusID <>2 
		--and EnrollmentStatusId <>27 
		and EnrollmentStatusId <>3
		and Studentstatusid in 
		(select distinct NEnrStatusID from #TBCurActive2)

			--select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID from #TBNextActive1


			INSERT INTO dbo.tmpStudentStatHistory
						select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
						from #TBNextActive1 

			 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
						AND EnrollmentStatusID <> 2 
					 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name=''TROCMAIL'',
				@recipients = ''etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu'', 
				@query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
				@subject = ''Student Status Change Report'',
				@body = ''IDs of Students whose Status have changed to CONTINUING this week:'' ;  
		  

				drop table #TBNextActive1
				drop table #TBCurActive2
				drop table #TBCurActive1
  
  
 END
 ELSE
 BEGIN
		 
		 --drop table #TBNextActive1
		 --drop table #TBCurActive2
		 --drop table #TBCurActive1
		 
		
		-- List of Student Registered in Current Term
		SELECT  dbo.CAMS_StudentStatus_View.StudentStatusID, dbo.CAMS_StudentStatus_View.StudentUID, dbo.Student.StudentID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID, dbo.CAMS_StudentStatus_View.TermCalendarID as CurrentTerm, 
		dbo.getStudentNextEnrolledTerm(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrTerm,
		dbo.getStudentNextEnrolledStatusID(dbo.CAMS_StudentStatus_View.StudentUID) as NEnrStatusID
	    INTO #TBCurActive11
		FROM  dbo.TermCalendar INNER JOIN
					   dbo.CAMS_StudentStatus_View ON dbo.TermCalendar.TermCalendarID = dbo.CAMS_StudentStatus_View.TermCalendarID INNER JOIN
					   dbo.EnrollmentStatus ON dbo.CAMS_StudentStatus_View.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID  INNER JOIN
					   dbo.Student ON dbo.CAMS_StudentStatus_View.StudentUID = dbo.Student.StudentUID
		WHERE (dbo.TermCalendar.ActiveFlag = ''True'') AND (dbo.TermCalendar.TextTerm =@CTerm)and dbo.CAMS_StudentStatus_View.StudentUID in
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

		-- List of students who have enrollment in other term whose status is not continuing or transfer
		select * 
		into #TBCurActive21
		from #TBCurActive11 
		where 
		NEnrTerm <>0
		and EnrollmentStatusID<>2 
		--and EnrollmentStatusID<>27


		--select * from #TBCurActive2

		-- List of students status  enrolled in other term whose status is not continuing or transfer
		select StudentStatusID,StudentUID,StudentID, EnrollmentStatus as Status, EnrollmentStatusID, StudentLoad
		into #TBNextActive11
		from dbo.CAMS_StudentStatus_View
		where StudentLoad <>'''' 
		and EnrollmentStatusID <>2 
		--and EnrollmentStatusId <>27 
		and Studentstatusid in 
		(select distinct NEnrStatusID from #TBCurActive21)

			--select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID from #TBNextActive1


			INSERT INTO dbo.tmpStudentStatHistory
						select StudentStatusID,StudentUID,StudentID, Status, EnrollmentStatusID, GETDATE() as SDATE, dbo.isStudentGraduated(StudentUID, @t) as Graduated  
						from #TBNextActive11

			 UPDATE dbo.StudentStatus set EnrollmentStatusID=2 WHERE StudentStatusID IN 
					   (SELECT StudentStatusID FROM dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(@Tday) AND MONTH(SDATE)=MONTH(@Tday) AND YEAR(SDATE)=YEAR(@Tday) And Graduated=0)
						AND EnrollmentStatusID <> 2 
					 	
		 	EXEC msdb.dbo.sp_send_dbmail 
				@profile_name=''TROCMAIL'',
				@recipients = ''etiennes@trocaire.edu;HornerT@Trocaire.edu;TomaselloN@Trocaire.edu;BallaroM@Trocaire.edu;MathenyJ@Trocaire.edu'', 
				@query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
				@subject = ''Student Status Change Report'',
				@body = ''IDs of Students whose Status have changed to CONTINUING this week:'' ;  
		  

				drop table #TBNextActive11
				drop table #TBCurActive21
				drop table #TBCurActive11
  
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


