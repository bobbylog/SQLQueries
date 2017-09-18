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
--drop table #TransacFilesV3
--drop table #NoSumTabForVerifTmp			
--drop table #NoSumTabVerif				
drop table #TransTbl		

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
			SELECT vst.* , (select f.StudentID from student f where f.StudentID=vst.Field4) as CAMSOFficial 
			into dbo.TransTbl
			FROM #Transv3 vst


			select distinct Field3, Field4, CAMSOFficial from dbo.TransTbl where CAMSOFficial is null

-- Send an email
EXEC msdb.dbo.sp_send_dbmail 
@profile_name='TROCMAIL',
@recipients = 'etiennes@trocaire.edu', 
@query = 'select distinct Field3, Field4, CAMSOFficial from CAMS_ENterprise.dbo.TransTbl where CAMSOFficial is null',
@subject = 'Students with Wrong IDs' ,
@body = 'List of Students with Wrong IDs: ' ;  


drop table dbo.TransTbl

drop table #Transv3
drop table #tmpDirectory1
drop table #TransacFilesV3

--drop table #TransTbl		