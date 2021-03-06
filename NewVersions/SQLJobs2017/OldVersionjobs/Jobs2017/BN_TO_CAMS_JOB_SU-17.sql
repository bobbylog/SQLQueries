USE [msdb]
GO

/****** Object:  Job [BN_TO_CAMS_JOB_SU-17]    Script Date: 05/12/2017 14:16:38 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 05/12/2017 14:16:38 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'BN_TO_CAMS_JOB_SU-17', 
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
/****** Object:  Step [Processing]    Script Date: 05/12/2017 14:16:38 ******/
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
		@command=N'Use CAMS_enterprise
--drop table #tmptable
--drop table #tmpret
--drop table #tmp

 Declare @BaID bigint
 Declare @Tm int
 DEclare @nc1 int
 Declare @nt bigint
 Declare @tnc bigint
 DEclare @pfld varchar(100)
 DEclare @rfld varchar(100)
 DEclare @cmd1 varchar(350)
 DEclare @cmd2 varchar(350)
 
 set @tnc=0
 set @nt=0
 set @Tm=615
 
 set @rfld=''SU17\Raw\''
 set @pfld=''SU17\Processed\''
 
 set @cmd1=  ''copy d:\sftp\barnes_noble\imports\AR*V3.csv d:\sftp\barnes_noble\imports\Archives\''+@rfld
								
 
 
 EXEC  master..xp_cmdshell ''echo Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 > d:\sftp\barnes_noble\imports\TransactionsProcessed.csv''
 
 EXEC  master..xp_cmdshell @cmd1
 EXEC  master..xp_cmdshell ''move d:\sftp\barnes_noble\imports\AR*V3.csv d:\sftp\barnes_noble\imports\FromBNCBData.csv''
 EXEC  master..xp_cmdshell ''type d:\sftp\barnes_noble\imports\FromBNCBData.csv >> d:\sftp\barnes_noble\imports\TransactionsProcessed.csv''
 
 select * --, GETDATE() as DateCollected
  into #TmpTable
from openrowset(''MSDASQL''
 ,''Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
 DefaultDir=D:\SFTP\barnes_noble\Imports\'' 
,''select * from TransactionsProcessed.csv'') T

--select * from #TmpTable

select distinct @nt=Field2 from #TmpTable
select @nc1=count(Field2) from #TmpTable

select @tnc=count(Transnum) from dbo.BN_Transmissions_History
where Transnum=@nt

if (@tnc=0) and (@nc1 >0)
	begin
	
			insert into dbo.BN_Transmissions_History(Transnum) values (@nt)

				 select Field1, Field2, Field3, Field4, Field5, Field6, reverse (stuff(REVERSE(Field7),3,0,''.'')) as Field71, Field8, Field9
				 into #Tmp
				 from #TmpTable


		-- select Field4, Field6, Field71 as Field7, Field8
		-- into #TmpRet
		-- from #Tmp
		 
		 select Field4, Field6, sum(cast (Field71 as numeric (5,2))) as FL7 , Field8
		 into #TmpRet1
		 from #Tmp
		 group by  Field8, Field4, Field6
		 
		 select Field4, Field6, cast (FL7 as varchar) as Field7 , Field8
		 into #TmpRet
		 from #TmpRet1

		--select * from #TmpRet

		DECLARE @nc int
		DECLARE @rc int
		DECLARE @rc1 int
		
		DECLARE @Topic varchar(300)
		DECLARE @Tbody varchar(500)
		
		
		set @Tbody=''''
		set @rc=0
		set @rc1=0

		select @nc=COUNT(Field4) from #TmpRet 

				if (@nc > 0)
					begin

							 
							 insert into dbo.BatchMaster(BatchName, UserID, CampusID,Comment, TransactionNo, SourceModuleID, TermBased, DepartmentID)
								values(''BN-ONLINE-''+cast(MONTH(GETDATE()) as varchar)+''-''+cast(DAY(GETDATE()) as varchar)+''-''+cast(YEAR(GETDATE()) as varchar),''TCCAMSMGR'',0,''Online B And N Transactions'',0,2,1,0)

							select top 1 @BaID=BatchMasterID from dbo.BatchMaster 
							where BatchName=(''BN-ONLINE-''+cast(MONTH(GETDATE()) as varchar)+''-''+cast(DAY(GETDATE()) as varchar)+''-''+cast(YEAR(GETDATE()) as varchar))

								DECLARE @name1 datetime
								DECLARE @name2 varchar(25)
								DECLARE @name3 varchar(25)
								DECLARE @name4 varchar(25)
								DECLARE @name5 varchar(25)
								DECLARE @name6 varchar(25)
								DECLARE @name7 varchar(25)
								DECLARE @name8 datetime

								
											DECLARE db_cursor CURSOR FOR  
											 select Field4,  Field6, Field7, Field8  from #TmpRet
											

											OPEN db_cursor   
											FETCH NEXT FROM db_cursor INTO @name4, @name6, @name7, @name8

											WHILE @@FETCH_STATUS = 0   
											BEGIN   
												   --print  @name4
												 --select dbo.getstudentUIDFromID (rtrim(ltrim(cast(@name4 as varchar))))
											     
												insert into BillingBatch (BatchMasterID,TermCalendarID,TransDate,TransdocID,TransType,OwnerUID, Description, 
														Amount,AmountFactor,ShowAmount, Debits, Credits,ARTypeID,InsertUserID, InsertTime,
														RefNo,ExtTypeId, CreditCardNum,CreditCardTypeID, A1098Deductible,UpdateUserID,DirectDepositBatch)
														VALUES
														(
														@BaID, 
														@Tm, 
														@name8, 
														418, 
														case @name6 when ''IN'' then ''DEBIT'' else ''CREDIT'' end ,
														dbo.getstudentUIDFromID(ltrim(rtrim(@name4))), 
														''BookStore Charges (BNA)'', 
														CAST (@name7 as numeric(5,2)),
														case @name6 when ''IN'' then 1 else -1 end, 
														case @name6 when ''IN'' then CAST (@name7 as numeric(5,2)) else -1 * CAST (@name7 as numeric(5,2)) end ,
														 case @name6 when ''IN'' then CAST (@name7 as numeric(5,2)) else 0 end, 
														case @name6 when ''IN'' then 0 else CAST (@name7 as numeric(5,2)) end ,
														0,
														''TCCAMSMGR'', 
														GETDATE(),0,0,0,0,0,'''','''' )
														
														set @rc1=@@ROWCOUNT
														set @rc=@rc+@rc1

												   FETCH NEXT FROM db_cursor INTO @name4, @name6, @name7, @name8
											END   

											CLOSE db_cursor   
											DEALLOCATE db_cursor
										
											set @cmd2= ''Move d:\sftp\barnes_noble\imports\FromBNCBData.csv d:\sftp\barnes_noble\imports\Archives\''+@pfld+''FromBNCBData''+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+''.csv''
											EXEC  master..xp_cmdshell @cmd2
											EXEC  master..xp_cmdshell ''echo Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 > d:\sftp\barnes_noble\imports\TransactionsProcessed.csv''
						
											set @Topic=''Batch ''+''BN-ONLINE-''+cast(MONTH(GETDATE()) as varchar)+''-''+cast(DAY(GETDATE()) as varchar)+''-''+cast(YEAR(GETDATE()) as varchar)+'' has been Uploaded with ''+cast(@rc as varchar)+'' transactions''
											set @Tbody=''Batch ''+''BN-ONLINE-''+cast(MONTH(GETDATE()) as varchar)+''-''+cast(DAY(GETDATE()) as varchar)+''-''+cast(YEAR(GETDATE()) as varchar)+'' has been Uploaded with ''+cast(@rc as varchar)+'' transactions. Please, check out Billing batch in CAMS.''
											-- Send an email
											EXEC msdb.dbo.sp_send_dbmail 
											@profile_name=''TROCMAIL'',
											@recipients = ''desbordesd@trocaire.edu;etiennes@trocaire.edu'', 
											-- @query = ''SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())'',
											@subject = @topic ,
											@body = @tbody ;  
						
											drop table #TmpRet1
											drop table #TmpRet
											drop table #Tmp
									 
						end		


		
end

drop table #TmpTable
', 
		@database_name=N'CAMS_Enterprise', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'BNTOCAMSSCHED', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170206, 
		@active_end_date=99991231, 
		@active_start_time=43000, 
		@active_end_time=235959, 
		@schedule_uid=N'c697c249-a4d6-46d6-b0bb-7d56a0e7479c'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


