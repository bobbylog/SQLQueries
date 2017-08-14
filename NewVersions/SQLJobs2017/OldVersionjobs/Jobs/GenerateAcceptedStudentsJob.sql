
DECLARE @qrybk1 VARCHAR(2500)
DECLARE @cterm varchar(25)

DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)


set @cterm='FA-17'


set @qrybk1 ='exec CAMS_enterprise.dbo.Generate_Accepted_Students '''+@cterm+''''

--print @qrybk1


set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; '+@qrybk1+'"  > D:\CAMSEnterprise\Bookstore\AcceptedStudents'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@cterm+'.csv'
set @filename1='D:\CAMSEnterprise\Bookstore\AcceptedStudents_'+@cterm+'.csv'
--print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic='Accepted Student File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= 'Dear Mollie, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached Accepted Student File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu', 
@file_attachments =@glfile,
-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
@subject = @topic ,
@body = @tbody ;  
