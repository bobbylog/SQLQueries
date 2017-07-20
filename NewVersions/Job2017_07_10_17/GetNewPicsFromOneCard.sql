USE [msdb]
GO

/****** Object:  Job [GetNewPicsFromOneCard]    Script Date: 07/20/2017 15:45:54 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 07/20/2017 15:45:54 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'GetNewPicsFromOneCard', 
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
/****** Object:  Step [GetPics]    Script Date: 07/20/2017 15:45:54 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'GetPics', 
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
use CAMS_Enterprise

-- Files from OneCards

IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\OneCard\1Card\PICTURES\'',1,1;



select * 
into #tmpRpt
from #tmpDirectory
--where subdirectory like ''%.rpt''
where isfile=1
and LEN(subdirectory)=10
order by subdirectory asc

select subdirectory, replace(subdirectory,''.'','''') as cfile , CAST(replace(subdirectory,''.'','''') as int) as ncor
into #Tmpdir1
from #tmpRpt


select subdirectory, cfile , cast(ncor as varchar)+''.jpg'' as picsname 
into #TmpDir2
from #Tmpdir1

--select * from #TmpDir2
--order by picsname asc

-- Files from Live Database

IF OBJECT_ID(''tempdb..#DirectoryTree'') IS NOT NULL
      DROP TABLE #tmpDirectory1;

CREATE TABLE #tmpDirectory1 (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory1 (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree ''D:\CamsEnterprise\Pics\'',1,1;

select * 
into #tmpRpt1
from #tmpDirectory1
order by subdirectory asc

select subdirectory, picsname 
into #NewPicSet
from #TmpDir2 where ltrim(rtrim(picsname))  not in 
(select ltrim(rtrim(subdirectory)) from #tmpRpt1)
and picsname <> ''9984.jpg''
order by picsname


select ''copy /y D:\OneCard\1Card\PICTURES\''+subdirectory+'' d:\CamsEnterprise\Pics\''+picsname as CommandFileTxt
into dbo.TmpDir3
from #NewPicSet

select ''copy /y D:\OneCard\1Card\PICTURES\''+subdirectory+'' d:\CamsEnterprise\StuPics\''+picsname as CommandFileTxt
into dbo.TmpDir4
from #NewPicSet

select * from dbo.TmpDir3





-- Exporting Command File


DECLARE @cmdstr nvarchar(max)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(1000)
DECLARE @filename1 nvarchar(300)

set @cmdstr= ''SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.TmpDir3"  > D:\CAMSEnterprise\TMPGMImport\UploadPics''
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+''_''+@tmstp+''.cmd''
set @filename1=''D:\CAMSEnterprise\TMPGMImport\UploadPics_''+@tmstp+''.cmd''
EXEC  master..xp_cmdshell @globalcmdstr
EXEC  master..xp_cmdshell @filename1

-- Exporting Stupics File
set @cmdstr= ''SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.TmpDir4"  > D:\CAMSEnterprise\TMPGMImport\UploadStuPics''
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+''_''+@tmstp+''.cmd''
set @filename1=''D:\CAMSEnterprise\TMPGMImport\UploadStuPics_''+@tmstp+''.cmd''
EXEC  master..xp_cmdshell @globalcmdstr
EXEC  master..xp_cmdshell @filename1

EXEC  master..xp_cmdshell ''move D:\CAMSEnterprise\TMPGMImport\*.cmd D:\CAMSEnterprise\TMPGMImport\Archives\''	
		
		

drop table dbo.Tmpdir4
drop table dbo.Tmpdir3
drop table #NewPicSet
drop table #Tmpdir2
drop table #Tmpdir1
drop table #tmpRpt
drop table #tmpdirectory

drop table #tmpRpt1
drop table #tmpdirectory1
', 
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


