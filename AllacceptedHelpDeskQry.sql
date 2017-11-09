--select top 10  * from studentportal

--select St1.studentID,St1.StudentUID,St1.FirstName,St1.LastName, dbo.getStudentEmailAddress(st1.StudentUID) as Email,
--(Select top 1 A.Portalhandle from studentportal A where A.StudentUID=ST1.Studentuid ) as UserID ,
--(Select top 1 B.PortalPassword from studentportal B where B.StudentUID=ST1.Studentuid ) as Password 
--from student St1 where cast(st1.AdmitDate as date)=dateadd(weekday,-1,cast(GETDATE() as date))

--select dateadd(weekday,-1,cast(GETDATE() as date))
-- Send an email
--EXEC msdb.dbo.sp_send_dbmail 
--@profile_name='TROCMAIL',
--@recipients = 'etiennes@trocaire.edu', 
--@query = 'select St1.studentID,St1.StudentUID,St1.FirstName,St1.LastName, cams_enterprise.dbo.getStudentEmailAddress(st1.StudentUID) as Email,
--(Select top 1 A.Portalhandle from cams_enterprise.dbo.studentportal A where A.StudentUID=ST1.Studentuid ) as UserID ,
--(Select top 1 B.PortalPassword from cams_enterprise.dbo.studentportal B where B.StudentUID=ST1.Studentuid ) as Password 
--from cams_enterprise.dbo.student St1 where cast(st1.AdmitDate as date)=''11/03/2017'' and studentID <>''--------------------''',
--@attach_query_result_as_file=1,
--@subject = 'Students Accepted Yesterday' ,
--@body = '<p>List of Students Accepted The prior day:</p>',  
--@body_format = 'HTML' ;  




DECLARE @qrybkstore VARCHAR(2500)

DECLARE @cmdstr varchar(2500)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(2500)
DECLARE @filename1 varchar(300)
--DECLARE @filename2 varchar(300)
--DECLARE @filename3 varchar(300)
--DECLARE @filename4 varchar(300)




select St1.studentID,St1.StudentUID,St1.FirstName,St1.LastName, cams_enterprise.dbo.getStudentEmailAddress(st1.StudentUID) as Email,
(Select top 1 A.Portalhandle from cams_enterprise.dbo.studentportal A where A.StudentUID=ST1.Studentuid ) as UserID ,
(Select top 1 B.PortalPassword from cams_enterprise.dbo.studentportal B where B.StudentUID=ST1.Studentuid ) as Password 
into dbo.TmpAccStuPass
from cams_enterprise.dbo.student St1 where cast(st1.AdmitDate as date)='11/03/2017'




-- print  @qrybkstore


set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; select * from cams_enterprise.dbo.Tmpaccstupass"  > D:\CAMSEnterprise\Bookstore\AllAccepted'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename1='D:\CAMSEnterprise\Bookstore\AllAccepted_'+@tmstp+'.csv'
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic='List of Accepted Students for Prior Day as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= '<p>Dear Help, </p>'+'<p>Please, find Attached List of Accepted Students for the prior day</p>'+'<p>Regards, <br/>CAMS Admin</p>'



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu', 
@file_attachments =@glfile,
@subject = @topic ,
@body = @tbody,
@body_format = 'HTML' ;  

drop table dbo.TmpAccStuPass
EXEC  master..xp_cmdshell 'del /F /Q D:\CAMSEnterprise\Bookstore\AllAccepted*.csv'
