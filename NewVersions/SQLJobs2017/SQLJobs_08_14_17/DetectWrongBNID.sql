USE [msdb]
GO

/****** Object:  Job [DetectWrongBNID]    Script Date: 12/26/2017 11:44:18 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/26/2017 11:44:18 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DetectWrongBNID', 
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
/****** Object:  Step [Processing]    Script Date: 12/26/2017 11:44:18 AM ******/
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
		@command=N'--drop table #NoSumTab
--drop table #withSumTab
--drop table #tmptab6
--drop table #TmpTab5
--drop table #TmpTab4
--drop table #TmpTab3
--drop table #tmptab
--drop table #Tmptab1
--drop table #Transv2			
--drop table #Transv3
--drop table #tmpDirectory1
--drop table #TransacFilesV3
--drop table #NoSumTabForVerifTmp			
--drop table #NoSumTabVerif				
--drop table #TransTbl		

IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory1;

CREATE TABLE #tmpDirectory1 (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory1 (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\'',1,1;



select  * 
into #TransacFilesV3
from #tmpDirectory1
where isfile=1
and subdirectory like ''AR%V3.csv'' 
and subdirectory not like ''%process%''
order by subdirectory asc



--select * from #TransacFilesV3






declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1
--declare @qry1 varchar(250)


DECLARE db_cursor1 CURSOR FOR  
			select  subdirectory from #TransacFilesV3
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd=''type "D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\'' + @name1+''" >> "D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\ProcessTransV3.csv"''
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell ''copy "D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\ProcessTransV3tpl.csv" "D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\ProcessTransV3.csv"'', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 print @Cpass
			 
				IF (@CPass=1)
				begin
					select * 
					into #Transv3
					from openrowset(''MSDASQL''
					 ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\'' 
					 ,''select * from ProcessTransV3.csv'') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv3
						select * 
						from openrowset(''MSDASQL''
						,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\SP18\Raw\'' 
						,''select * from ProcessTransV3.csv'') T
					
					END
					
						set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor1 INTO  @name1
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			
			--SELECT * FROM #Transv2
			SELECT vst.* , (select f.StudentID from student f where f.StudentID=vst.Field4) as CAMSOFficial 
			into dbo.TransTbl
			FROM #Transv3 vst

			declare @nc int

			set @nc=(select distinct count(Field3) from dbo.TransTbl where CAMSOFficial is null)

-- Send an email

if @nc >0
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name=''TROCMAIL'',
	@recipients = ''etiennes@trocaire.edu;desbordesd@trocaire.edu;packardt@trocaire.edu'', 
	@query = ''select distinct Field3, Field4, CAMSOFficial from CAMS_ENterprise.dbo.TransTbl where CAMSOFficial is null'',
	@subject = ''Students with Wrong IDs'' ,
	@body = ''List of Students with Wrong IDs: '' ;  


drop table dbo.TransTbl

drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesV3

--drop table #TransTbl		', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'DTCSCHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170915, 
		@active_end_date=99991231, 
		@active_start_time=110000, 
		@active_end_time=235959, 
		@schedule_uid=N'd3bc5eab-aa41-457c-a178-6258b32fb1b5'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


