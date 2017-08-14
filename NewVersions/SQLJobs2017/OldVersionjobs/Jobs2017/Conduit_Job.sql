USE [msdb]
GO

/****** Object:  Job [Conduit_Job]    Script Date: 05/12/2017 14:17:58 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:17:58 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Conduit_Job', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\etiennes', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Processing]    Script Date: 05/12/2017 14:17:58 ******/
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
DECLARE @cmdstr varchar(200)
DECLARE @cmdstr1 varchar(200)
DECLARE @cmdstr2 varchar(200)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(215)

set @cmdstr= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; exec CAMS_enterprise.dbo.Conduit_getUserAccountList"  > D:\Conduit\user''
set @cmdstr1= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; exec CAMS_enterprise.dbo.Conduit_getCourseList"  > D:\Conduit\course''
set @cmdstr2= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; exec CAMS_enterprise.dbo.Conduit_getEnrollList"  > D:\Conduit\enroll''
--set @tmstp=LEFT(CONVERT(VARCHAR, FORMAT(getdate(), ''yyyyMMdd''), 120), 10)
set @tmstp=CONVERT(char(8), GETDATE(), 112)

set @globalcmdstr = @cmdstr+''.csv''
EXEC  master..xp_cmdshell ''del D:\Conduit\*user*''
EXEC  master..xp_cmdshell @globalcmdstr

set @globalcmdstr = @cmdstr1+''.csv''
EXEC  master..xp_cmdshell ''del D:\Conduit\*course*''
EXEC  master..xp_cmdshell @globalcmdstr

set @globalcmdstr = @cmdstr2+''.csv''
EXEC  master..xp_cmdshell ''del D:\Conduit\*enroll*''
EXEC  master..xp_cmdshell @globalcmdstr




GO
', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'CondSched', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20161219, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=190000, 
		@schedule_uid=N'3a7313e8-258f-4af0-94d4-e1c8995c5fba'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


