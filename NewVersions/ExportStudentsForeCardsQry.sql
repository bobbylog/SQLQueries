--drop table #StudExport
use CAMS_Enterprise
Select * 
into #StudExport
From CUS_GeneralMetersExport_View 
WHERE (1=1)  
AND (TypeID IN (2633,2634))  
AND (AddressTypeID = 287)  
AND (TermCalendarID = 614)  
AND ExpectedTermSeq Between 'B16Q' AND 'B17C' 
AND ((AdmitDate Between '12/30/1899 12:00:00 am' AND '12/31/9999 11:59:59 pm') OR (AdmitDate is Null)) 

drop table dbo.TmpfStuExport2
select '*'+cast(Studentuid as varchar)  as suid,'&' as s1,'2' as fc1,' ' as blk1,'31/12/2025' as dt1,FirstName, LastName, MiddleInitial, Address1,City, State, ZipCode, Phone1,' ' as blk2,' ' as blk3,LEFT(CONVERT(VARCHAR, BirthDate, 120), 10) as BDate,' ' as blk4,' ' as blk5,' ' as blk6,' ' as blk7,' ' as blk8,' ' as blk9,' ' as blk10,' ' as blk11,Email1,' ' as blk12,' ' as blk13,' ' as blk14,' ' as blk15,' ' as blk16,' ' as blk17,' ' as blk18,' ' as blk19,' ' as blk20,'&' as s2,'17' as fc2, StudentID,'C' as fc3 
into dbo.TmpfStuExport2
from #StudExport



-- Exporting Mailmerge File

DECLARE @cmdstr nvarchar(max)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(1000)
DECLARE @cterm varchar(15)
DECLARE @filename1 nvarchar(300)

				
	
	set @cmdstr= 'SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; select * from CAMS_Enterprise.dbo.TmpfStuExport2"  > D:\CAMSEnterprise\TMPGMExport\GMData'
	set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
	set @globalcmdstr = @cmdstr+'_'+@tmstp+'.cnm'
	set @filename1='D:\CAMSEnterprise\TMPGMExport\GMData_'+@tmstp+'.cnm'
	
	EXEC  master..xp_cmdshell 'del D:\CAMSEnterprise\TMPGMExport\*.*'
	EXEC  master..xp_cmdshell @globalcmdstr
	


drop table #StudExport