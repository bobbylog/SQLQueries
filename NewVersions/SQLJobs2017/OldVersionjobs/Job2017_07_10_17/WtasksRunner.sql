USE [msdb]
GO

/****** Object:  Job [WtasksRunner]    Script Date: 07/20/2017 15:52:13 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/20/2017 15:52:13 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'WtasksRunner', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'TROCAIRE\etiennes', 
		@notify_email_operator_name=N'System Admin', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Processing]    Script Date: 07/20/2017 15:52:13 ******/
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
DECLARe @Token int
DECLARe @nc int
DECLARE @dt datetime
DECLARE @cdt varchar(108)

declare @topic varchar(300)
declare @tbody varchar(300)

set @Token=0
set @dt=GETDATE()
set @cdt=convert(varchar(10), GETDATE(), 108)

-- If time between 10:52 and 11:08:00
--if (@cdt between ''10:52:00'' and ''11:10:00'')
  --EXEC  master..xp_cmdshell ''schtasks /run /tn Testscr''

--select @Token as TOK

IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\SFTP\keybank\Exports\'',1,1;


select @nc=COUNT(subdirectory) 
from #tmpDirectory
where isfile=1

if (@nc >0)
    begin

	    EXEC  master..xp_cmdshell ''schtasks /run /tn WinscpKeybankSync''
  
    end

DROP TABLE #tmpDirectory;
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'WTASKRUNSCHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170405, 
		@active_end_date=99991231, 
		@active_start_time=141000, 
		@active_end_time=235959, 
		@schedule_uid=N'6fcef7ab-4854-40be-bcb8-d5b059af13a5'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


