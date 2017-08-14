USE [msdb]
GO

/****** Object:  Job [BKSTORE_ENROLLFILE_SU17]    Script Date: 8/14/2017 10:31:10 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 8/14/2017 10:31:10 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'BKSTORE_ENROLLFILE_SU17', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\EtienneS', 
		@notify_email_operator_name=N'System Admin', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ProcessingFile]    Script Date: 8/14/2017 10:31:10 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ProcessingFile', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @qrybkstore VARCHAR(2500)
DECLARE @qrybk1 VARCHAR(2500)
DECLARE @qrybk2 VARCHAR(2500)
DECLARE @qrybk3 VARCHAR(2500)
DECLARE @cterm varchar(25)

DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)
DECLARE @filename2 varchar(300)
DECLARE @filename3 varchar(300)
DECLARE @filename4 varchar(300)


set @cterm=''SU-17''

set @qrybk1=''SELECT DISTINCT ''''1'''' AS Code, TextTerm, Department, Course, Section, REPLACE(FacultyLastName + '''', '''' + FacultyFirstName, '''','''','''' '''') AS FacultyName, MaximumEnroll, CurrentEnroll, '''''''' AS Blank1,'' 
set @qrybk2='''''''''' AS Blank2, '''''''' AS Blank3, '''''''' AS Blank4, '''''''' AS Blank5, REPLACE(CourseName,'''','''','''' '''') as CourseName''
set @qrybk3 ='' FROM  CAMS_ENTERPRISE.dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View WHERE (TextTerm = ''''SU-17'''')''
set @qrybkstore=@qrybk1+@qrybk2+@qrybk3

-- print  @qrybkstore


set @cmdstr= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; ''+@qrybkstore+''"  > D:\CAMSEnterprise\Bookstore\EnrollmentFile''
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+''_''+@tmstp+''.csv''
set @filename1=''D:\CAMSEnterprise\Bookstore\EnrollmentFile_''+@tmstp+''.csv''
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic=''Enrollment File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= ''Dear Debbie, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Please, find Attached Enrollment File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name=''TROCMAIL'',
@recipients = ''sm8183@bncollege.com;Cammaratad@Trocaire.edu;etiennes@trocaire.edu'', 
@file_attachments =@glfile,
-- @query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
@subject = @topic ,
@body = @tbody ;  
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ENRSCHED1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=2, 
		@active_start_date=20170306, 
		@active_end_date=99991231, 
		@active_start_time=71500, 
		@active_end_time=235959, 
		@schedule_uid=N'dd50342a-ac9d-43a5-bf09-c9da4f7305c9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


