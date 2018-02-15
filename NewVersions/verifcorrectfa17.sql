drop table #NoSumTab
drop table #withSumTab
drop table #tmptab6
drop table #TmpTab5
drop table #TmpTab4
drop table #TmpTab3
drop table #tmptab
drop table #Tmptab1
drop table #Transv2			
drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesV3
drop table #NoSumTabForVerifTmp			
drop table #NoSumTabVerif				


IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory1;

CREATE TABLE #tmpDirectory1 (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory1 (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\',1,1;



select  * 
into #TransacFilesV3
from #tmpDirectory1
where isfile=1
and subdirectory like 'AR%V3.csv' 
and subdirectory not like '%process%'
order by subdirectory asc



--select * from #TransacFilesV3






declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1
--declare @qry1 varchar(250)


DECLARE db_cursor1 CURSOR FOR  
			select  subdirectory from #TransacFilesV3
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd='type "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\' + @name1+'" >> "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\ProcessTransV3.csv"'
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell 'copy "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\ProcessTransV3tpl.csv" "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\ProcessTransV3.csv"', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 print @Cpass
			 
				IF (@CPass=1)
				begin
					select * 
					into #Transv3
					from openrowset('MSDASQL'
					 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\' 
					 ,'select * from ProcessTransV3.csv') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv3
						select * 
						from openrowset('MSDASQL'
						,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\' 
						,'select * from ProcessTransV3.csv') T
					
					END
					
						set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor1 INTO  @name1
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			
			--SELECT * FROM #Transv2
			--SELECT * FROM #Transv3

--select Field1 as TransDate, Field3 as Custname, Field4 as StudentID, Field6 as Amount, CASE WHEN Field7='IN' THEN 'DEBIT' ELSE 'CREDIT' END as TransType 
--into #TmpTab
--from #Transv2
--union all
select Field8 as TransDate, Field3 as Custname, Field4 as StudentID, Field7 as Amount, CASE WHEN Field6='IN' THEN 'DEBIT' ELSE 'CREDIT' END as Transtype 
into #TmpTab
from #Transv3


select TransDate, Custname, StudentID,  reverse (stuff(REVERSE(Amount),3,0,'.')) as Amount1 , TransType 
into #Tmptab1
from #Tmptab
order by studentid

select TransDate, Custname, StudentID,  case when transtype='CREDIT' then -1* cast(Amount1 as numeric(6,2)) else cast(Amount1 as numeric(6,2)) end as Amount2 , TransType 
into #Tmptab4
from #Tmptab1
order by studentid


--select TransDate, Custname, StudentID,  case when transtype='CREDIT' then -1* sum(cast(Amount1 as numeric(6,2))) else sum(cast(Amount1 as numeric(6,2)))   end as Amount2, TransType 
--into #tmptab6
--From #Tmptab1
--group by TransDate,StudentID,Custname, TransType

--select *

 
--into #NoSumTab
--from #Tmptab4



drop table dbo.NoSumTabForVerif

--select * , case when CAMSBatchAmt IS not null then 'Yes' else 'No' end as HitBatch,
--case when CAMSLedgerAmt IS not null then 'Yes' else 'No' end as HitLedger
--into #NoSumTabForVerifTmp
--from #NoSumTab 

--order by transdate, Custname asc

select Transdate, Custname, StudentID, Sum (cast (Amount2 as numeric(6,2))) as Amount , Transtype
--HitBatch, HitLedger
into #NoSumTabForVerifTmp
from #Tmptab4
 group by  Transdate, StudentID, Transtype, custname
 order by Custname asc

 select *  
  , 
[dbo].[getVerifiedStuBatchAmount] (
 dbo.getStudentUIDFromID(StudentID),
 --3,
 TransType,
 TransDate,
 Amount
 
) as CAMSBatchAmt,
[dbo].[getVerifiedStuLedgerAmount] (
 dbo.getStudentUIDFromID(StudentID),
 --3,
 TransType,
 TransDate,
 Amount
 
) as CAMSLedgerAmt
into #NoSumTabVerif
from #NoSumTabForVerifTmp
order by custname asc


select * , case when CAMSBatchAmt IS not null then 'Yes' else 'No' end as HitBatch,
case when CAMSLedgerAmt IS not null then 'Yes' else 'No' end as HitLedger
into dbo.NoSumTabForVerif
from #NoSumTabVerif
order by  Transdate, Custname asc

   
DECLARE @cmdstr varchar(350)
DECLARE @tmstp varchar(50)
DECLARE @globalcmdstr varchar(500)
DECLARE @filename1 varchar(100)
DECLARE @cterm varchar(25)

set @cterm='FA-17'
set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on; SELECT * FROM CAMS_ENTERPRISE.dbo.NoSumTabForVerif"  > D:\CAMSEnterprise\Bookstore\BNAVerifFA17'
--print  @cmdstr
set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
set @filename1='D:\CAMSEnterprise\Bookstore\BNAVerifFA17_'+@tmstp+'.csv'
print @globalcmdstr
EXEC  master..xp_cmdshell @globalcmdstr

				
declare @glfile varchar(max)
declare @topic varchar(300)
declare @tbody varchar(300)
set @topic='Barnes and Nobles Weekly Verification File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
set @glfile=@filename1
set @tbody= 'Dear Damian, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached the Barnes and Nobles Weekly Verification File for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '



-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu', 
@file_attachments =@glfile,
-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
@subject = @topic ,
@body = @tbody ;  

EXEC  master..xp_cmdshell 'del D:\CAMSEnterprise\Bookstore\BNAVerif*.csv'

drop table #NoSumTab
--drop table #withSumTab
--drop table #tmptab6
--drop table #TmpTab5
drop table #TmpTab4
--drop table #TmpTab3
drop table #tmptab
drop table #Tmptab1
--drop table #Transv2			
drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesV3
drop table #NoSumTabForVerifTmp
drop table #NoSumTabVerif			