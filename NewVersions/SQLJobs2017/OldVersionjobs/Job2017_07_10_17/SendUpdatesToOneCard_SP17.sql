USE [msdb]
GO

/****** Object:  Job [SendUpdatesToOneCard_SP17]    Script Date: 07/20/2017 15:50:05 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/20/2017 15:50:05 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'SendUpdatesToOneCard_SP17', 
		@enabled=0, 
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
/****** Object:  Step [Processing]    Script Date: 07/20/2017 15:50:05 ******/
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
		@command=N'--drop table #StudExport
use CAMS_Enterprise
Select * 
into #StudExport
From CUS_GeneralMetersExport_View 
WHERE (1=1)  
AND (TypeID IN (2633,2634))  
AND (AddressTypeID = 287)  
AND (TermCalendarID = 614)  
AND ExpectedTermSeq Between ''B16Q'' AND ''B17C'' 
AND ((AdmitDate Between ''12/30/1899 12:00:00 am'' AND ''12/31/9999 11:59:59 pm'') OR (AdmitDate is Null)) 

drop table dbo.TmpfStuExport2
select ''*''+cast(Studentuid as varchar)  as suid,''&'' as s1,''2'' as fc1,'' '' as blk1,''31/12/2025'' as dt1,FirstName, LastName, MiddleInitial, Address1,City, State, ZipCode, Phone1,'' '' as blk2,'' '' as blk3,LEFT(CONVERT(VARCHAR, BirthDate, 120), 10) as BDate,'' '' as blk4,'' '' as blk5,'' '' as blk6,'' '' as blk7,'' '' as blk8,'' '' as blk9,'' '' as blk10,'' '' as blk11,Email1,'' '' as blk12,'' '' as blk13,'' '' as blk14,'' '' as blk15,'' '' as blk16,'' '' as blk17,'' '' as blk18,'' '' as blk19,'' '' as blk20,''&'' as s2,''17'' as fc2, StudentID,''C'' as fc3 
into dbo.TmpfStuExport2
from #StudExport



-- Exporting Mailmerge File

DECLARE @cmdstr nvarchar(max)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(1000)
DECLARE @cterm varchar(15)
DECLARE @filename1 nvarchar(300)

				
	
	set @cmdstr= ''SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; select * from CAMS_Enterprise.dbo.TmpfStuExport2"  > D:\CAMSEnterprise\TMPGMExport\GMData''
	set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
	set @globalcmdstr = @cmdstr+''_''+@tmstp+''.cnm''
	set @filename1=''D:\CAMSEnterprise\TMPGMExport\GMData_''+@tmstp+''.cnm''
	
	EXEC  master..xp_cmdshell ''del D:\CAMSEnterprise\TMPGMExport\*.*''
	EXEC  master..xp_cmdshell @globalcmdstr
	


drop table #StudExport', 
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


