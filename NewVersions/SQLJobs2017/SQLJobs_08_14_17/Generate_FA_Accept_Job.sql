USE [msdb]
GO

/****** Object:  Job [Generate_FA_Accept_Job]    Script Date: 8/14/2017 10:37:06 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 8/14/2017 10:37:06 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Generate_FA_Accept_Job', 
		@enabled=1, 
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
/****** Object:  Step [Processing]    Script Date: 8/14/2017 10:37:06 AM ******/
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
		@command=N'use CAMS_Enterprise



-- Exporting  File

	DECLARE @cmdstr nvarchar(max)
	DECLARE @tmstp varchar(15)
	DECLARE @globalcmdstr varchar(1000)
	DECLARE @cterm varchar(15)
	DECLARE @filename1 nvarchar(300)

				
	--set @cmdstr= ''SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; EXEC CAMS_Enterprise.dbo.GenerateTmpfStuExport2"  > D:\CAMSEnterprise\TMPGMExport\GMData''
	set @cmdstr= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; EXEC CAMS_Enterprise.dbo.CTM_Generate_FA_Accept_Rpt"  > D:\CAMSEnterprise\Finaid\FA_Accept''
	set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
	set @globalcmdstr = @cmdstr+''_''+@tmstp+''.csv''
	set @filename1=''D:\CAMSEnterprise\Finaid\FA_Accept_''+@tmstp+''.csv''

	--print @globalcmdstr
	EXEC  master..xp_cmdshell ''del /F /Q D:\CAMSEnterprise\Finaid\*.*''
	EXEC  master..xp_cmdshell @globalcmdstr

				
	declare @glfile varchar(max)
	declare @topic varchar(300)
	declare @tbody varchar(300)
	set @topic=''FA_Accept was executed on ''+CONVERT(VARCHAR, GETDATE())
	set @glfile=@filename1
	set @tbody= ''Dear Financial Aid Office, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Here is today''''s report. Report any issues, problems, or questions to helpdesk@trocaire.edu.''
			+CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''


	-- Send an email
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name=''TROCMAIL'',
	@recipients = ''germonoa@trocaire.edu;adamczykt@trocaire.edu;smithj@trocaire.edu;CooksC@Trocaire.edu;LucasJ@Trocaire.edu;'', 
	@copy_recipients=''etiennes@trocaire.edu'',
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
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'FASCHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170811, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'32d77450-58c8-44ab-8d85-38cfa6996d40'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


