USE [msdb]
GO

/****** Object:  Job [BNToCAMSWeeklyVerifJob_SU17]    Script Date: 8/14/2017 10:32:13 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 8/14/2017 10:32:13 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'BNToCAMSWeeklyVerifJob_SU17', 
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
/****** Object:  Step [Processing]    Script Date: 8/14/2017 10:32:13 AM ******/
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
			
			


IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory1;

CREATE TABLE #tmpDirectory1 (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory1 (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\'',1,1;



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
			 
			 set @gblcmd=''type "D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\'' + @name1+''" >> "D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\ProcessTransV3.csv"''
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell ''copy "D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\ProcessTransV3tpl.csv" "D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\ProcessTransV3.csv"'', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 print @Cpass
			 
				IF (@CPass=1)
				begin
					select * 
					into #Transv3
					from openrowset(''MSDASQL''
					 ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\'' 
					 ,''select * from ProcessTransV3.csv'') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv3
						select * 
						from openrowset(''MSDASQL''
						,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\SU17\Raw\'' 
						,''select * from ProcessTransV3.csv'') T
					
					END
					
						set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor1 INTO  @name1
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			
			--SELECT * FROM #Transv2
			--SELECT * FROM #Transv3

--select Field1 as TransDate, Field3 as Custname, Field4 as StudentID, Field6 as Amount, CASE WHEN Field7=''IN'' THEN ''DEBIT'' ELSE ''CREDIT'' END as TransType 
--into #TmpTab
--from #Transv2
--union all
select Field8 as TransDate, Field3 as Custname, Field4 as StudentID, Field7 as Amount, CASE WHEN Field6=''IN'' THEN ''DEBIT'' ELSE ''CREDIT'' END as Transtype 
into #TmpTab
from #Transv3


select TransDate, Custname, StudentID,  reverse (stuff(REVERSE(Amount),3,0,''.'')) as Amount1 , TransType 
into #Tmptab1
from #Tmptab
order by studentid

select TransDate, Custname, StudentID,  case when transtype=''CREDIT'' then -1* cast(Amount1 as numeric(5,2)) else cast(Amount1 as numeric(5,2)) end as Amount2 , TransType 
into #Tmptab4
from #Tmptab1
order by studentid


--select TransDate, Custname, StudentID,  case when transtype=''CREDIT'' then -1* sum(cast(Amount1 as numeric(5,2))) else sum(cast(Amount1 as numeric(5,2)))   end as Amount2, TransType 
--into #tmptab6
--From #Tmptab1
--group by TransDate,StudentID,Custname, TransType

select * , 
[dbo].[getVerifiedStuBatchAmount] (
 dbo.getStudentUIDFromID(StudentID),
 --3,
 TransType,
 TransDate,
 Amount2
 
) as CAMSBatchAmt,
[dbo].[getVerifiedStuLedgerAmount] (
 dbo.getStudentUIDFromID(StudentID),
 --3,
 TransType,
 TransDate,
 Amount2
 
) as CAMSLedgerAmt

 
into #NoSumTab
from #Tmptab4

--select * , 
--[dbo].[getVerifiedStuLedgerAmount] (
-- dbo.getStudentUIDFromID(StudentID),
-- 2,
-- TransType,
-- TransDate,
-- Amount2
 
--) as CAMSLedgerAmt 
--into #withSumTab
--from #Tmptab6

drop table dbo.NoSumTabForVerif
select * , case when CAMSBatchAmt IS not null then ''Yes'' else ''No'' end as HitBatch,
case when CAMSLedgerAmt IS not null then ''Yes'' else ''No'' end as HitLedger
into dbo.NoSumTabForVerif
from #NoSumTab 
--where CAMSBatchAmt  is not null 
order by transdate, Custname asc

--select * from #NoSumTab where CAMSBatchAmt  is null order by transdate, Custname asc

DECLARE @cmdstr varchar(350)
DECLARE @tmstp varchar(50)
DECLARE @globalcmdstr varchar(500)
DECLARE @filename1 varchar(100)
DECLARE @cterm varchar(25)

set @cterm=''SU-17''
set @cmdstr= ''SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; SELECT * FROM CAMS_ENTERPRISE.dbo.NoSumTabForVerif"  > D:\CAMSEnterprise\Bookstore\BNAVerifSU17''
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+''_''+@tmstp+''.csv''
set @filename1=''D:\CAMSEnterprise\Bookstore\BNAVerifSU17_''+@tmstp+''.csv''
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic=''Barnes and Nobles Weekly Verification File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= ''Dear Damian, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Please, find Attached the Barnes and Nobles Weekly Verification File for ''+@cterm+ '' as of ''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+''Regards, ''+CHAR(13)+CHAR(13)+CHAR(10)+''Senghor E ''



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name=''TROCMAIL'',
@recipients = ''desbordesd@trocaire.edu;etiennes@trocaire.edu'', 
@file_attachments =@glfile,
-- @query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
@subject = @topic ,
@body = @tbody ;  

EXEC  master..xp_cmdshell ''del D:\CAMSEnterprise\Bookstore\BNAVerif*.csv''

drop table #NoSumTab
--drop table #withSumTab
--drop table #tmptab6
--drop table #TmpTab5
drop table #TmpTab4
--drop table #TmpTab3
drop table #tmptab
drop table #Tmptab1
--drop table #Transv2			
drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesV3
			', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BNVERIFSHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=33, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170517, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'30341bfa-5544-4b9f-b5cb-0f75a8c6d004'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


