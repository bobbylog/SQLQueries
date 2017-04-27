--drop table #NoSumTab
--drop table #withSumTab
--drop table #tmptab6
--drop table #TmpTab5
--drop table #TmpTab4
--drop table #TmpTab3
--drop table #tmptab
--drop table #Tmptab1
--drop table #Transv2			
--drop table #Transv3
--drop table #tmpDirectory1
--drop table #TransacFilesFebV3


--drop table #Transv3
--drop table #tmpDirectory1
--drop table #TransacFilesFebV3
			


IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory1;

CREATE TABLE #tmpDirectory1 (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory1 (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\JoanneFiles\March\',1,1;



select  * 
into #TransacFilesFebV3
from #tmpDirectory1
where isfile=1
and subdirectory like '%V3.csv' 
and subdirectory not like '%process%'
order by subdirectory asc



--select * from #TransacFilesFebV3






declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1
--declare @qry1 varchar(250)


DECLARE db_cursor1 CURSOR FOR  
			select  subdirectory from #TransacFilesFebV3
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd='type "D:\JoanneFiles\March\' + @name1+'" >> "D:\JoanneFiles\March\ProcessTransV3.csv"'
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell 'copy "D:\JoanneFiles\March\ProcessTransV3tpl.csv" "D:\JoanneFiles\March\ProcessTransV3.csv"', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 print @Cpass
			 
				IF (@CPass=1)
				begin
					select * 
					into #Transv3
					from openrowset('MSDASQL'
					 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\JoanneFiles\March\' 
					 ,'select * from ProcessTransV3.csv') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv3
						select * 
						from openrowset('MSDASQL'
						,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\JoanneFiles\March\' 
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

select TransDate, Custname, StudentID,  case when transtype='CREDIT' then -1* cast(Amount1 as numeric(5,2)) else cast(Amount1 as numeric(5,2)) end as Amount2 , TransType 
into #Tmptab4
from #Tmptab1
order by studentid


--select TransDate, Custname, StudentID,  case when transtype='CREDIT' then -1* sum(cast(Amount1 as numeric(5,2))) else sum(cast(Amount1 as numeric(5,2)))   end as Amount2, TransType 
--into #tmptab6
--From #Tmptab1
--group by TransDate,StudentID,Custname, TransType

select * , 
[dbo].[getVerifiedStuLedgerAmount] (
 dbo.getStudentUIDFromID(StudentID),
 3,
 TransType,
 TransDate,
 Amount2
 
) as CAMSLedgerAmt 
into #NoSumTab
from #Tmptab4

--select * , 
--[dbo].[getVerifiedStuLedgerAmount] (
-- dbo.getStudentUIDFromID(StudentID),
-- 2,
-- TransType,
-- TransDate,
-- Amount2
 
--) as CAMSLedgerAmt 
--into #withSumTab
--from #Tmptab6


select * from #NoSumTab where CAMSLedgerAmt is not null order by transdate, Custname asc

select * from #NoSumTab where CAMSLedgerAmt is null order by transdate, Custname asc




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
drop table #TransacFilesFebV3
			