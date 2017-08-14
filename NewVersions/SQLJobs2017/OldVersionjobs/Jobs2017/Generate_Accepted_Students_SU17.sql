USE [msdb]
GO

/****** Object:  Job [Generate_Accepted_Students_SU17]    Script Date: 05/12/2017 14:19:15 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:19:15 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Generate_Accepted_Students_SU17', 
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
/****** Object:  Step [Processing]    Script Date: 05/12/2017 14:19:15 ******/
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
DECLARE @qrybk1 VARCHAR(2500)
DECLARE @cterm varchar(25)

DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)


set @cterm=''SU-17''


set @qrybk1 =''exec CAMS_enterprise.dbo.Generate_Accepted_Students ''''''+@cterm+''''''''

--print @qrybk1


set @cmdstr= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; ''+@qrybk1+''"  > D:\CAMSEnterprise\Bookstore\AcceptedStudents''
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+''_''+@cterm+''.csv''
set @filename1=''D:\CAMSEnterprise\Bookstore\AcceptedStudents_''+@cterm+''.csv''
--print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic=''Accepted Student File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= ''Dear Mollie, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Please, find Attached Accepted Student File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name=''TROCMAIL'',
@recipients = ''BallaroM@Trocaire.edu;etiennes@trocaire.edu'', 
@file_attachments =@glfile,
-- @query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
@subject = @topic ,
@body = @tbody ;  
', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'ACEPTSCHED1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170417, 
		@active_end_date=20170421, 
		@active_start_time=91500, 
		@active_end_time=235959, 
		@schedule_uid=N'aec09144-f861-4d6d-9d1f-023eed47e8a1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


