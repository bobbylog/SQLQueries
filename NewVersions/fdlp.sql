--Drop table #ExamFiles
--Drop table #collectScore
--Drop table #TmpCollect
--Drop table #TmpCollect1
--Drop table #TmpTable
--drop table #Lt1
--drop table #LoanTemp
-- drop table #FedLoanT
-- drop table #LoanFiles
-- drop table #tmpDirectory
DECLARE @RefFolder varchar(200)
DECLARE @DriverRef varchar(250)

set @RefFolder='D:\FedLoans\SU17SP18FA18\COD loan reports\'
set @DriverRef='Driver={Microsoft Access Text Driver (*.txt, *.csv)};DefaultDir='+ @RefFolder+''''

IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree @RefFolder,1,1;



select * 
into #LoanFiles
from #tmpDirectory
where isfile=1
and subdirectory not like 'Processed%'
order by subdirectory asc

select * from #LoanFiles

declare @name1 varchar(50)
DECLARE @gblcmd1 varchar(200)
DECLARE @gblcmd2 varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1
declare @qry1 varchar(250)


DECLARE db_cursor CURSOR FOR  
			select  subdirectory from #LoanFiles
			
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				
		
			
    		set @gblcmd1='copy "' + @RefFolder+'ProcessedLoanFilesTpl.csv" "'+@RefFolder+'ProcessedLoanFiles.csv"'
    		
    		set @gblcmd2='type "'+@RefFolder+@name1+'" >> "'+@RefFolder+'ProcessedLoanFiles.csv"'
    		
			--print @gblcmd
			
			EXEC  master..xp_cmdshell @gblcmd1
		    EXEC  master..xp_cmdshell @gblcmd2
		    
			print @name1
			print @Cpass
			
			
			IF (@CPass=1)
			begin
				select 
				* 
				
				into #FedLoanT
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=D:\FedLoans\SU17SP18FA18\COD loan reports\'
				 ,'select * from ProcessedLoanFiles.csv') T
			
			END
			
			IF (@CPass>1)
			begin
			
				Insert into #FedLoanT
				select * 
				from openrowset('MSDASQL'
				 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				 DefaultDir=D:\FedLoans\SU17SP18FA18\COD loan reports\' 
				 ,'select * from ProcessedLoanFiles.csv') T
			
			END
			
					set @CPass=@CPass+1
					
				   
	         --select * from #FedLoanT
	         
				   FETCH NEXT FROM db_cursor INTO  @name1
			END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor

	select 	
	LOANID,SCHOOLID,FIRSTNAME,LASTNAME,SSNP,TYPE,AWARDID,POSTDATE,BOOKEDDATE,
	DISBDATE,DISBNUM,DISBSEQ,GAMOUNT,FEEAMOUNT,REBATE,NETAMOUNT,NETDISB
	into #LoanTemp
	from #FedLoanT
	
	select * ,
	cast ( substring( awardid, 1,  patindex('%S%', Awardid)-1 ) as numeric)  as SSNS  
	into #LT1
	from #LoanTemp
	where TYPE='S'
	union all
	select * ,
	cast ( substring( awardid, 1,  patindex('%U%', Awardid)-1 ) as numeric)  as SSNS  
	from #LoanTemp
	where TYPE='U'
	union all
	select * ,
	cast ( substring( awardid, 1,  patindex('%P%', Awardid)-1 ) as numeric)  as SSNS  
	from #LoanTemp
	where TYPE='P'
	
	
	drop table dbo.FedDataForRecon
	
	select * 
	into
	dbo.FedDataForRecon
	from #LT1
	
	select * from dbo.FedDataForRecon
	
	
	
	
	--union all
	--select * , patindex('%S%', Awardid) as ind
	--from #LoanTemp
	--where TYPE='S'
	--union all
	--select * , patindex('%P%', Awardid) as ind
	--from #LoanTemp
	--where TYPE='P'
	
drop table #Lt1
 drop table #LoanTemp
 drop table #FedLoanT
 drop table #LoanFiles
 drop table #tmpDirectory