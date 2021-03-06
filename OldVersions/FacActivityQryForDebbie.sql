DECLARE @cmdstr nvarchar(max)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(1000)
DECLARE @filename1 nvarchar(300)
DECLARE @filename2 nvarchar(300)
DECLARE @filename3 nvarchar(300)
DECLARE @filename4 nvarchar(300)
declare @glfile nvarchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
				
-- Exporting actitity file for all
set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF;set nocount on; exec CAMS_Enterprise.dbo.TCC_Faculty_Activity_All"  > D:\CAMSEnterprise\FacActivity\FacActAll'
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename1='D:\CAMSEnterprise\FacActivity\FacActAll_'+@tmstp+'.csv'
EXEC  master..xp_cmdshell @globalcmdstr

-- Exporting actitity file for all
set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF;set nocount on; exec CAMS_Enterprise.dbo.TCC_Faculty_Activity_Education"  > D:\CAMSEnterprise\FacActivity\FacActEducation'
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename2='D:\CAMSEnterprise\FacActivity\FacActEducation_'+@tmstp+'.csv'
EXEC  master..xp_cmdshell @globalcmdstr

				
-- Generating Email content				

set @topic='Faculty Activity Files as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
-- set @glfile=@filename1+ ';'+@filename2+';'+@filename3+';'+@filename4
set @glfile=@filename1+ ';'+@filename2
-- set @glfile=@filename3
set @tbody= 'Dear Debbie, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached the Faculty activity files CPR, Education, Licensure for as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
            CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '

-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu;SteriovskiD@Trocaire.edu', 
@file_attachments =@glfile,
-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
@subject = @topic ,
@body = @tbody ;  




