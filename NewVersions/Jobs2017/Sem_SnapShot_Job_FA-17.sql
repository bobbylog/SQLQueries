USE [msdb]
GO

/****** Object:  Job [Sem_SnapShot_Job_FA-17]    Script Date: 05/12/2017 14:22:10 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:22:10 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Sem_SnapShot_Job_FA-17', 
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
/****** Object:  Step [Processing]    Script Date: 05/12/2017 14:22:10 ******/
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
		@command=N'DECLARe @Token int
DECLARe @nc int
DECLARE @dt datetime
DECLARE @cdt varchar(108)
DECLARE @Tm varchar(25)

declare @topic varchar(300)
declare @tbody varchar(300)


set @Token=0
set @dt=GETDATE()
set @cdt=convert(varchar(10), GETDATE(), 108)
set @Tm=''FA-17''

-- 2 Weeks Term Shaphots

--If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
--BEGIN
--	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 0
	
--		set @topic=''2 Weeks snapshot Captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
--		set @tbody= ''Dear Nicole, ''+CHAR(13)+CHAR(13)+CHAR(10)+''The 2 weeks snapshot has been captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
--        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''


--		-- Send an email
--		EXEC msdb.dbo.sp_send_dbmail 
--		@profile_name=''TROCMAIL'',
--		@recipients = ''TomaselloN@Trocaire.edu;etiennes@trocaire.edu'', 
--		@subject = @topic ,
--		@body = @tbody ; 
	
--END

-- First Day Snapshot

If (MONTH(@dt)=08 and DAY(@dt)=21 aND YEAR(@dt)=2017)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 1


		set @topic=''First Day snapshot Captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= ''Dear Nicole, ''+CHAR(13)+CHAR(13)+CHAR(10)+''The First Day snapshot has been captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''

	
		-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name=''TROCMAIL'',
		@recipients = ''TomaselloN@Trocaire.edu;etiennes@trocaire.edu'', 
		@subject = @topic ,
		@body = @tbody ; 
	
END


-- Drop Add Snapshot

If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 2

		set @topic=''Drop/Add snapshot Captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= ''Dear Nicole, ''+CHAR(13)+CHAR(13)+CHAR(10)+''The Drop/Add snapshot has been captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''

	
		-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name=''TROCMAIL'',
		@recipients = ''TomaselloN@Trocaire.edu;etiennes@trocaire.edu'', 
		@subject = @topic ,
		@body = @tbody ; 
		
END

-- Term Snapshot / Official Snapshot

If (MONTH(@dt)=10 and DAY(@dt)=15 aND YEAR(@dt)=2017)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 3

		set @topic=''Official snapshot Captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= ''Dear Nicole, ''+CHAR(13)+CHAR(13)+CHAR(10)+''The Official snapshot has been captured for ''+@tm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''

	
	-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name=''TROCMAIL'',
		@recipients = ''TomaselloN@Trocaire.edu;etiennes@trocaire.edu'', 
		@subject = @topic ,
		@body = @tbody ;  

END

	

', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SNAPSCHED-ADRP', 
		@enabled=1, 
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170929, 
		@active_end_date=99991231, 
		@active_start_time=90656, 
		@active_end_time=235959, 
		@schedule_uid=N'acaf8d63-fe03-498b-8a8d-a82c0b926482'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SNAPSCHED-FST', 
		@enabled=1, 
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20170821, 
		@active_end_date=99991231, 
		@active_start_time=90035, 
		@active_end_time=235959, 
		@schedule_uid=N'7c3a6a23-bea8-4495-bcf1-9f23e72dc170'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'SNAPSCHED-OFF', 
		@enabled=1, 
		@freq_type=1, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20171015, 
		@active_end_date=99991231, 
		@active_start_time=90011, 
		@active_end_time=235959, 
		@schedule_uid=N'ba9dd660-170b-4d38-b176-d9d2eccb82e9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


