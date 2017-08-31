

--drop table #ExcepTab
--drop table #files
--drop table #FileTab

DECLARE @BFOLDER varchar(200)
declare @name1 varchar(250)
DECLARE @gblcmd varchar(500)
DECLARE @gblcmd1 varchar(500)
DECLARE @gblcmd2 varchar(500)
DECLARE @gblcmd3 varchar(500)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)


set @BFOLDER='CAMS_Enterprise'


set @gblcmd='dir D:\SQLBackup\'+@BFOLDER+'\'

create table #files (name varchar(500))

insert into #files
EXEC xp_cmdshell @gblcmd;


select cast (left(name,17) as datetime ) as FileDate, REVERSE(SUBSTRING(REVERSE(name),0,CHARINDEX(' ',REVERSE(name)))) as FileName
into #FileTab
from #files 
     -- dates start with numeric --check assumption carefully...
     where isnumeric(left(name,1))=1 
	 
     --order by date desc       --
    order by CAST(left(name,17) as datetime) desc

select * 
into #ExcepTab
from #FileTab
where FileDate between DATEADD(DAY,-14,GETDATE()) and DATEADD(DAY,1,GETDATE())
and fileName <> '.' and Filename <> '..'

select * 
into #ForDelTab
from #FileTab
where FileName not in 
(select FileName from #ExcepTab)
and fileName <> '.' and Filename <> '..'



set @CPass=1
--declare @qry1 varchar(250)

select * from #ForDelTab

DECLARE db_cursor1 CURSOR FOR  
			select  FileName from #ForDelTab
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
			 
			 set @gblcmd1='echo del /F /Q D:\SQLBackup\'+@BFOLDER+'\' + @name1+' >> D:\SQLBackup\'+@BFOLDER+'\ForDel.cmd'
			print @gblcmd1
			
			 --EXEC  master..xp_cmdshell 'copy "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\ProcessTransV3tpl.csv" "D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\ProcessTransV3.csv"', no_output
		     EXEC  master..xp_cmdshell @gblcmd1, no_output
			-- print @Cpass
			 
				--IF (@CPass=1)
				--begin
				--	select * 
				--	into #Transv3
				--	from openrowset('MSDASQL'
				--	 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				--	 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\' 
				--	 ,'select * from ProcessTransV3.csv') T
				
				--END
				
				--IF (@CPass>1)
				--	begin
					
				--		Insert into #Transv3
				--		select * 
				--		from openrowset('MSDASQL'
				--		,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
				--		 DefaultDir=D:\SFTP\barnes_noble\Imports\Archives\FA17\Raw\' 
				--		,'select * from ProcessTransV3.csv') T
					
				--	END
					
				--		set @CPass=@CPass+1
		
				   
	       
				   FETCH NEXT FROM db_cursor1 INTO  @name1
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			

			 set @gblcmd2='D:\SQLBackup\'+@BFOLDER+'\ForDel.cmd'
			 set @gblcmd3='del /F /Q D:\SQLBackup\'+@BFOLDER+'\ForDel.cmd'
			


			EXEC  master..xp_cmdshell @gblcmd2, no_output
			EXEC  master..xp_cmdshell @gblcmd3, no_output


drop table #ForDelTab
drop table #ExcepTab
drop table #files
drop table #FileTab



--select * from #TransacFilesV3

