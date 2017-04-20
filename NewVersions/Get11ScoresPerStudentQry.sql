 --drop table #ExamFiles
--drop table #tmpDirectory
--drop table #TmpCollect
--Drop table #TmpTable
--drop table #tmpDirectory

IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\Scores\',1,1;



--select  * 
--into #ExamFiles
--from #tmpDirectory
--where isfile=1
--and subdirectory not like 'Processed%'
--order by subdirectory asc

--select * from #ExamFiles



 
 EXEC  master..xp_cmdshell 'copy d:\scores\ProcessedScoresTpl.csv d:\scores\ProcessedScores.csv'
 EXEC  master..xp_cmdshell 'type d:\scores\24663934.txt >> d:\scores\ProcessedScores.csv'
	
	 select * 
	  into #TmpTable
	from openrowset('MSDASQL'
	 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
	 DefaultDir=D:\Scores\' 
	,'select * from ProcessedScores.csv') T

--	select dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) as OwnerUID, Field3, Field4, Field15, Field28, Field29,Field30 
---	from #TmpTable

	select * from #TmpTable
	    
	    DECLARE @nc1 varchar(50)
	    DECLARE @nc2 varchar(50)
	    DECLARE @nc3 varchar(50)
	    
		SELECT @nc1=Field28, @nc2=Field29, @nc3=Field30 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   --insert into #TmpcollectScore (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
		   
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field28, Field29,Field30 
						into #TmpCollect
						from #TmpTable
				
						
		   end
		   
		   
		
		SELECT @nc1=Field32, @nc2=Field33, @nc3=Field34 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field32, Field33,Field34 
						from #TmpTable
						
		   end
		   
		   
		SELECT @nc1=Field36, @nc2=Field37, @nc3=Field38 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field36, Field37,Field38 
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field40, @nc2=Field41, @nc3=Field42 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field40, Field41,Field42 
						from #TmpTable
						
		   end
		   
		SELECT @nc1=Field44, @nc2=Field45, @nc3=Field46 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field44, Field45,Field46 
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field48, @nc2=Field49, @nc3=Field50 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field48, Field49,Field50
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field52, @nc2=Field53, @nc3=Field54 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field52, Field53,Field54
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field56, @nc2=Field57, @nc3=Field58 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field56, Field57,Field58
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field60, @nc2=Field61, @nc3=Field62 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field60, Field61,Field62
						from #TmpTable
						
		   end
		
		SELECT @nc1=Field64, @nc2=Field65, @nc3=Field66 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field64, Field65,Field66
						from #TmpTable
						
		   end
		
		
		SELECT @nc1=Field68, @nc2=Field69, @nc3=Field70 from #TmpTable
		if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
		   begin
		   insert into #Tmpcollect (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field68, Field69,Field70
						from #TmpTable
						
		   end
		
	select * from #TmpCollect
	
	
	
	
	
	drop table #TmpCollect
	Drop table #TmpTable
	
	drop table #tmpDirectory
    --drop table #ExamFiles