drop table #tmpDirectory
drop table #TransacFilesFebV2

drop table #TmpTab4
drop table #TmpTab3
drop table #tmptab
drop table #Tmptab1
drop table #Transv2			
drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesFebV3
			

IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\JoanneFiles\Feb\',1,1;



select  * 
into #TransacFilesFebV2
from #tmpDirectory
where isfile=1
and subdirectory like '%V2.csv' 
and subdirectory not like '%process%'
order by subdirectory asc



--select * from #TransacFilesFebV2






declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
--DECLARE @nc1 varchar(50)
--DECLARE @nc2 varchar(50)
--DECLARE @nc3 varchar(50)

set @CPass=1
--declare @qry1 varchar(250)


DECLARE db_cursor CURSOR FOR  
			select  subdirectory from #TransacFilesFebV2
			
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd='type "D:\JoanneFiles\Feb\' + @name1+'" >> "D:\JoanneFiles\Feb\ProcessTransV2.csv"'
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell 'copy "D:\JoanneFiles\Feb\ProcessTransV2tpl.csv" "D:\JoanneFiles\Feb\ProcessTransV2.csv"', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 
				IF (@CPass=1)
				begin
					select 
					* 
					into #Transv2
					from openrowset('MSDASQL'
					 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\JoanneFiles\Feb\' 
					 ,'select * from ProcessTransV2.csv') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv2
						select * 
						from openrowset('MSDASQL'
						,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\JoanneFiles\Feb\' 
						,'select * from ProcessTransV2.csv') T
					
					END
					
							set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor INTO  @name1
			END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor
			
			--SELECT * FROM #Transv2
			

--drop table #Transv2
drop table #tmpDirectory
drop table #TransacFilesFebV2


----v3 table --------------------------------------------------------------------------

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
EXEC master.sys.xp_dirtree 'D:\JoanneFiles\Feb\',1,1;



select  * 
into #TransacFilesFebV3
from #tmpDirectory1
where isfile=1
and subdirectory like '%V3.csv' 
and subdirectory not like '%process%'
order by subdirectory asc



--select * from #TransacFilesFebV3






--declare @name1 varchar(50)
--DECLARE @gblcmd varchar(200)

--DECLARE @CPass int;
--DECLARE @nc1 varchar(50)
--DECLARE @nc2 varchar(50)
--DECLARE @nc3 varchar(50)

set @CPass=1
--declare @qry1 varchar(250)


DECLARE db_cursor1 CURSOR FOR  
			select  subdirectory from #TransacFilesFebV3
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd='type "D:\JoanneFiles\Feb\' + @name1+'" >> "D:\JoanneFiles\Feb\ProcessTransV3.csv"'
			--print @gblcmd
			
			 EXEC  master..xp_cmdshell 'copy "D:\JoanneFiles\Feb\ProcessTransV3tpl.csv" "D:\JoanneFiles\Feb\ProcessTransV3.csv"', no_output
		     EXEC  master..xp_cmdshell @gblcmd, no_output
			 print @Cpass
			 
				IF (@CPass=1)
				begin
					select * 
					into #Transv3
					from openrowset('MSDASQL'
					 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
					 DefaultDir=D:\JoanneFiles\Feb\' 
					 ,'select * from ProcessTransV3.csv') T
				
				END
				
				IF (@CPass>1)
					begin
					
						Insert into #Transv3
						select * 
						from openrowset('MSDASQL'
						,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\JoanneFiles\Feb\' 
						,'select * from ProcessTransV3.csv') T
					
					END
					
						set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor1 INTO  @name1
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			
			--SELECT * FROM #Transv2
			--SELECT * FROM #Transv3

select Field1 as TransDate, Field3 as Custname, Field4 as StudentID, Field6 as Amount, CASE WHEN Field7='IN' THEN 'DEBIT' ELSE 'CREDIT' END as TransType 
into #TmpTab
from #Transv2
union all
select Field8 as TransDate, Field3 as Custname, Field4 as StudentID, Field7 as Amount, CASE WHEN Field6='IN' THEN 'DEBIT' ELSE 'CREDIT' END as Transtype from #Transv3


select TransDate, Custname, StudentID,  reverse (stuff(REVERSE(Amount),3,0,'.')) as Amount1 , TransType 
into #Tmptab1
from #Tmptab
order by studentid

select TransDate, Custname, StudentID,  case when transtype='CREDIT' then -1* sum(cast(Amount1 as numeric(5,2))) else sum(cast(Amount1 as numeric(5,2)))   end as Amount2, TransType 
into #tmptab4
From #Tmptab1
group by TransDate,StudentID,Custname, TransType

--select 

--select * from Billing 
--where 
--MONTH(TransDate)=2
--and YEAR(Transdate)=2017
--AND TransDOCID=418
--AND Description like '%(BNA)%'
--order  by Owneruid


select A1.*, B.TransDate AS TransDateB, B.TransType As transtypeb, B.Description, B.ShowAmount 
into #tmptab3
from #Tmptab4 A1
left outer join
          Billing AS B ON 
          A1.Amount2 = B.ShowAmount
          AND
           A1.StudentID = dbo.getstudentidfromuid(B.Owneruid)
          AND A1.transdate = B.TransDate 
          AND A1.transtype=b.transtype
          
 
where 
MONTH(B.TransDate)=2
and YEAR(B.Transdate)=2017
AND B.TransDOCID=418
AND B.Description like '%(BNA)%'
order  by A1.StudentID

select A1.*, B.TransDate AS TransDateB, B.TransType As transtypeb, B.Description, B.ShowAmount 
into #tmptab5
from #Tmptab1 A1
left outer join
          Billing AS B ON 
          A1.Amount1 = B.ShowAmount
          AND
           A1.StudentID = dbo.getstudentidfromuid(B.Owneruid)
          AND A1.transdate = B.TransDate 
          AND A1.transtype=b.transtype
          
 
where 
MONTH(B.TransDate)=2
and YEAR(B.Transdate)=2017
AND B.TransDOCID=418
AND B.Description like '%(BNA)%'
order  by A1.StudentID





--select distinct StudentID, Custname
--From #tmptab4
--where
--studentid not in
--(
--select distinct StudentId from #tmptab3)
--order by Studentid asc


--select * from #tmptab4 where StudentID='A0000006642'
--select * from Billing where OwnerUID=dbo.getStudentUIDFromID('A0000006642')
--and MONTH(TransDate)=2
--and YEAR(Transdate)=2017
--AND TransDOCID=418
--AND Description like '%(BNA)%'



--select distinct owneruiD as sids from billing
--where OwneruID not in
--(
--select distinct dbo.getstudentuidfromid(studentid) from #tmptab3
--)
--And MONTH(TransDate)=2
--and YEAR(Transdate)=2017
--AND TransDOCID=418
--AND Description like '%(BNA)%'


--select distinct StudentID, Custname from #tmptab3
--where StudentID not in
--(
--select distinct dbo.getstudentidfromuid(owneruid) from Billing 
--where 
--MONTH(TransDate)=2
--and YEAR(Transdate)=2017
--AND TransDOCID=418
--AND Description like '%(BNA)%'

--)

select * 
into #tmptab6
from #tmptab3
union
select * from #tmptab5

select distinct StudentID, Custname
From #tmptab4
where
studentid not in
(
select distinct StudentId from #tmptab6)
order by Studentid asc



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
			