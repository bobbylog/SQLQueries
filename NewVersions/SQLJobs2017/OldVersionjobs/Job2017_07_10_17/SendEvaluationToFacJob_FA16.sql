USE [msdb]
GO

/****** Object:  Job [SendEvaluationToFacJob_FA16]    Script Date: 07/20/2017 15:49:19 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/20/2017 15:49:19 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'SendEvaluationToFacJob_FA16', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\etiennes', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Processing]    Script Date: 07/20/2017 15:49:19 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Processing', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
USE CAMS_Enterprise
					
DECLARE @name1 varchar(25)
DECLARE @name2 varchar(300)
DECLARE @name3 varchar(25)
DECLARE @name4 varchar(300)
DECLARE @name5 varchar(25)
DECLARE @name6 varchar(25)
DECLARE @name7 varchar(25)
DECLARE @name8 datetime
DECLARE @i int
DECLARE @k int
DECLARE @j varchar(25)


			set @i=1
			set @j=CAST(@i as varchar)
			
			DECLARE db_cursor5 CURSOR FOR  
			
			SELECT DISTINCt 
				CAMS_rptSrofferType1000_View.SemesterID,
				CAMS_rptSrofferType1000_View.FacultyID, 
				SROffer.CourseID,
				SROffer.Section
			FROM  dbo.SROffer AS SROffer INNER JOIN
				dbo.CAMS_RptSROfferType1000_View AS CAMS_rptSrofferType1000_View ON SROffer.SROfferID = CAMS_rptSrofferType1000_View.SROfferID AND 
				SROffer.TermCalendarID = CAMS_rptSrofferType1000_View.SemesterID INNER JOIN
				dbo.CrsEvalQuestions AS CrsEvalQuestions INNER JOIN
				dbo.CrsEvalResponse AS CrsEvalResponse ON CrsEvalQuestions.QuestionID = CrsEvalResponse.QuestionID ON 
				SROffer.SROfferID = CrsEvalResponse.SrofferID LEFT OUTER JOIN
				dbo.CAMS_RptCourseEvalMCResponse_View AS CAMS_RptCourseEvalMCResponse_View ON 
				CrsEvalResponse.QuestionID = CAMS_RptCourseEvalMCResponse_View.QuestionID AND 
				CrsEvalResponse.SrofferID = CAMS_RptCourseEvalMCResponse_View.SROfferID
			WHERE (CAMS_rptSrofferType1000_View.SemesterID = 612) 
		    order by SROffer.courseID
			
			OPEN db_cursor5   
			FETCH NEXT FROM db_cursor5 INTO @name1 , @name2 , @name3, @name4

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				   exec dbo.COM_GetCourseEvaluationQuestionCounts @name1,@name2,@name3,@name4
			       
				   FETCH NEXT FROM db_cursor5 INTO  @name1 , @name2, @name3, @name4
			END   

			CLOSE db_cursor5   
			DEALLOCATE db_cursor5



', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


