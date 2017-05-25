
--drop table #NeedsAttention1
--drop table #NeedsAttention2

-- drop table #camsScore

SELECT dbo.CAMS_Test.CAMS_TestID, dbo.CAMS_Test.CAMS_TestRefID, dbo.CAMS_Test.OwnerID,dbo.getStudentFullName(dbo.getStudentIDFromUID(OwnerID)) as sname, dbo.CAMS_Test.TestDate, dbo.CAMS_Test.Note, 
               dbo.CAMS_Test.InsertUserID, dbo.CAMS_TestScore.Score, dbo.CAMS_TestScore.CAMS_TestScoreID, dbo.CAMS_TestScore.CAMS_TestScoreRefID
               ,[dbo].[getVerifiedStuBatchScore] (
							Ownerid,
							Testdate,
							Score,
							CAMS_TestScoreRefID) As ScoreInBatch
into #camsScore						
FROM  dbo.CAMS_Test INNER JOIN
               dbo.CAMS_TestScore ON dbo.CAMS_Test.CAMS_TestID = dbo.CAMS_TestScore.CAMS_TestID
WHERE
 (MONTH(dbo.CAMS_Test.TestDate) = MONTH(GETDATE())
  AND DAY(dbo.CAMS_Test.TestDate) = DAY(GETDATE())
  AND YEAR(dbo.CAMS_Test.TestDate) = YEAR(GETDATE())
  )
  -- CONVERT(DATETIME, '2017-05-23 00:00:00', 102))
  AND (dbo.CAMS_Test.CAMS_TestRefID = 12)

---------------------------------------------------------------------------------------


select Ownerid, sname, Testdate, 
(dbo.getScoreNameFromID(CAMS_TestScoreRefID)) as Testname, Score,
ScoreInBatch as ImportStatus
into #NeedsAttention1
from #camsScore



select OwnerUID as Ownerid , (FirstName+' '+ Lastname) as sname, TestDate, TestName, Score1, [dbo].[getVerifiedStuCAMSTestScore] (
OwnerUID,
Testdate,
Score1,
TestName
) as  ImportStatus
into #NeedsAttention2
 from testScoreBatch 
where BNum=dbo.getSScoreBatchNum()
and
Authorized in (1,0)
and Lastname is not null
and Firstname is not null


drop table dbo.ctm_camsScoreSource
select Ownerid,sname as FullName, Testdate, Testname as TestName1, Score, 'CAMS' as ScoreSource, 
 case when ImportStatus IS not null then 'Hit' else 'Score or ID not recognized' end as Status
 into dbo.ctm_camsScoreSource
 from #NeedsAttention1
 --order by sname asc

 
 drop table dbo.ctm_camsBatchSource
 select Ownerid,sname as FullName, Testdate, Testname as TestName1, Score1, 'Batch' as ScoreSource,
 case when ImportStatus IS not null then 'Hit' else 'Not Imported' end as Status
 into dbo.ctm_camsBatchSource
 from #NeedsAttention2
 order by scoresource, sname asc




DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)
DECLARE @filename2 varchar(300)
DECLARE @filename3 varchar(300)
DECLARE @filename4 varchar(300)





set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; Select * from CAMS_Enterprise.dbo.ctm_camsScoreSource "  > D:\CAMSEnterprise\Bookstore\CAMSVerifFile'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename1='D:\CAMSEnterprise\Bookstore\CAMSVerifFile_'+@tmstp+'.csv'
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr


set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; Select * from CAMS_Enterprise.dbo.ctm_camsBatchSource "  > D:\CAMSEnterprise\Bookstore\BatchVerifFile'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename2='D:\CAMSEnterprise\Bookstore\BatchVerifFile_'+@tmstp+'.csv'
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr


				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic='Score Import Status verification File as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1+ ';'+@filename2
set @tbody= 'Dear Test Administrators, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached the Score Import Status verification File for as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu', 
@file_attachments =@glfile,
-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
@subject = @topic ,
@body = @tbody ;  




--select * from dbo.ctm_camsScoreSource
--select * from dbo.ctm_camsBatchSource



drop table #NeedsAttention1
drop table #NeedsAttention2

 drop table #camsScore
