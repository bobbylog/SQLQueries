DECLARE @qrybkstore VARCHAR(2500)
DECLARE @qrybk1 VARCHAR(2500)
DECLARE @qrybk2 VARCHAR(2500)
DECLARE @qrybk3 VARCHAR(2500)
DECLARE @cterm varchar(25)

DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)
DECLARE @filename2 varchar(300)
DECLARE @filename3 varchar(300)
DECLARE @filename4 varchar(300)


set @cterm='SP-17'

set @qrybk1='SELECT DISTINCT ''1'' AS Code, TextTerm, Department, Course, Section, REPLACE(FacultyLastName + '', '' + FacultyFirstName, '','','' '') AS FacultyName, MaximumEnroll, CurrentEnroll, '''' AS Blank1,' 
set @qrybk2=''''' AS Blank2, '''' AS Blank3, '''' AS Blank4, '''' AS Blank5, REPLACE(CourseName,'','','' '') as CourseName'
set @qrybk3 =' FROM  CAMS_ENTERPRISE.dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View WHERE (TextTerm = ''SP-17'')'
set @qrybkstore=@qrybk1+@qrybk2+@qrybk3

-- print  @qrybkstore


set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; '+@qrybkstore+'"  > D:\CAMSEnterprise\Bookstore\EnrollmentFile'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename1='D:\CAMSEnterprise\Bookstore\EnrollmentFile_'+@tmstp+'.csv'
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic='Enrollment File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= 'Dear Amanda, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached Enrollment File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'SM8183@bncollege.com; bksgeneseecc@bncollege.com;etiennes@trocaire.edu', 
@file_attachments =@glfile,
-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
@subject = @topic ,
@body = @tbody ;  
