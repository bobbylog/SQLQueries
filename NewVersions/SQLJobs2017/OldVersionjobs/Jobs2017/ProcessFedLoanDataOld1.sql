USE [msdb]
GO

/****** Object:  Job [ProcessFedLoanData]    Script Date: 05/12/2017 14:21:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:21:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'ProcessFedLoanData', 
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
/****** Object:  Step [Processing]    Script Date: 05/12/2017 14:21:41 ******/
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
		@command=N'--Drop table #ExamFiles
--Drop table #collectScore
--Drop table #TmpCollect
--Drop table #TmpCollect1
--Drop table #TmpTable
--drop table #Lt1
--drop table #LoanTemp
-- drop table #FedLoanT
-- drop table #LoanFiles
-- drop table #tmpDirectory

IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\FedLoans\FASU16SP17\COD loan reports'',1,1;



select  * 
into #LoanFiles
from #tmpDirectory
where isfile=1
and subdirectory not like ''Processed%''
order by subdirectory asc

-- select * from #LoanFiles

declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1
declare @qry1 varchar(250)


DECLARE db_cursor CURSOR FOR  
			select  subdirectory from #LoanFiles
			
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				
		
			
    		set @gblcmd=''type "D:\FedLoans\FASU16SP17\COD loan reports\'' + @name1+''" >> "D:\FedLoans\FASU16SP17\COD loan reports\ProcessedLoanFiles.csv"''
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell ''copy "D:\FedLoans\FASU16SP17\COD loan reports\ProcessedLoanFilesTpl.csv" "D:\FedLoans\FASU16SP17\COD loan reports\ProcessedLoanFiles.csv"''
		     EXEC  master..xp_cmdshell @gblcmd
	
			--Insert into CAMS_Liaison_Inquiries
			IF (@CPass=1)
			begin
				select 
				* 
				--LOANID,SCHOOLID,FIRSTNAME,LASTNAME,SSNP,TYPE,AWARDID,POSTDATE,BOOKEDDATE,DISBDATE,DISBNUM,DISBSEQ,GAMOUNT,FEEAMOUNT,REBATE,NETAMOUNT,NETDISB,SSNS
				into #FedLoanT
				from openrowset(''MSDASQL''
				 ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=D:\FedLoans\FASU16SP17\COD loan reports\'' 
				 ,''select * from ProcessedLoanFiles.csv'') T
			
			END
			
			IF (@CPass>1)
			begin
			
				Insert into #FedLoanT
				select * 
				from openrowset(''MSDASQL''
				 ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=D:\FedLoans\FASU16SP17\COD loan reports\'' 
				 ,''select * from ProcessedLoanFiles.csv'') T
			
			END
			
					set @CPass=@CPass+1
					
				   
	       
				   FETCH NEXT FROM db_cursor INTO  @name1
			END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor

	select 	
	LOANID,SCHOOLID,FIRSTNAME,LASTNAME,SSNP,TYPE,AWARDID,POSTDATE,BOOKEDDATE,
	DISBDATE,DISBNUM,DISBSEQ,GAMOUNT,FEEAMOUNT,REBATE,NETAMOUNT,NETDISB
	into #LoanTemp
	from #FedLoanT
	
	select * ,
	cast ( substring( awardid, 1,  patindex(''%S%'', Awardid)-1 ) as numeric)  as SSNS  
	into #LT1
	from #LoanTemp
	where TYPE=''S''
	union all
	select * ,
	cast ( substring( awardid, 1,  patindex(''%U%'', Awardid)-1 ) as numeric)  as SSNS  
	from #LoanTemp
	where TYPE=''U''
	union all
	select * ,
	cast ( substring( awardid, 1,  patindex(''%P%'', Awardid)-1 ) as numeric)  as SSNS  
	from #LoanTemp
	where TYPE=''P''
	
	
	drop table dbo.FedDataForRecon
	
	select * 
	into
	dbo.FedDataForRecon
	from #LT1
	
	select * from dbo.FedDataForRecon
	
	
	
	
	--union all
	--select * , patindex(''%S%'', Awardid) as ind
	--from #LoanTemp
	--where TYPE=''S''
	--union all
	--select * , patindex(''%P%'', Awardid) as ind
	--from #LoanTemp
	--where TYPE=''P''
	
drop table #Lt1
 drop table #LoanTemp
 drop table #FedLoanT
 drop table #LoanFiles
 drop table #tmpDirectory', 
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


