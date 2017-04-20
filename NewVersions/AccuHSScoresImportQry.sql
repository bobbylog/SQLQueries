Drop table #TmpTable1
Drop table #tmpDirectory
Drop table #ExamFiles
Drop table #collectScore
Drop table #TmpCollect
Drop table #TmpCollect1
Drop table #TmpTable



IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\Scores\',1,1;



select  * 
into #ExamFiles
from #tmpDirectory
where isfile=1
and subdirectory not like 'Processed%'
order by subdirectory asc

--select * from #ExamFiles

declare @name1 varchar(50)
DECLARE @gblcmd varchar(200)

DECLARE @CPass int;
DECLARE @nc1 varchar(50)
DECLARE @nc2 varchar(50)
DECLARE @nc3 varchar(50)

set @CPass=1


DECLARE db_cursor CURSOR FOR  
			select  subdirectory from #ExamFiles
			
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @name1

			WHILE @@FETCH_STATUS = 0   
			BEGIN   
				
				IF (@CPass=1)
				 BEGIN
					 set @gblcmd='type d:\scores\' + @name1+'>> d:\scores\ProcessedScores.csv'
					 
					 EXEC  master..xp_cmdshell 'copy d:\scores\ProcessedScoresTpl.csv d:\scores\ProcessedScores.csv'
				     EXEC  master..xp_cmdshell @gblcmd
						
						 select * --, GETDATE() as DateCollected
						  into #TmpTable
						from openrowset('MSDASQL'
						 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\Scores\' 
						,'select * from ProcessedScores.csv') T

						--select dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) as OwnerUID, Field3, Field4, Field15, Field28, Field29,Field30 
						--into #collectScore
						--from #TmpTable
						
						
						
					    
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
										
						select * 
						into #collectScore
						from #TmpCollect
						
						drop table #TmpCollect
						Drop table #TmpTable
						
				 END
				 
				 IF (@CPass>1)
				 BEGIN
					
						 set @gblcmd='type d:\scores\' + @name1+'>> d:\scores\ProcessedScores.csv'
							
						 EXEC  master..xp_cmdshell 'copy d:\scores\ProcessedScoresTpl.csv d:\scores\ProcessedScores.csv'
						 EXEC  master..xp_cmdshell @gblcmd
						 
						 select * --, GETDATE() as DateCollected
						  into #TmpTable1
						from openrowset('MSDASQL'
						 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
						 DefaultDir=D:\Scores\' 
						,'select * from ProcessedScores.csv') T
						--select * from #TmpTable1

					    
						SELECT @nc1=Field28, @nc2=Field29, @nc3=Field30 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   --insert into #TmpcollectScore (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						   
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field28, Field29,Field30 
										into #TmpCollect1
										from #TmpTable1
								
										
						   end
						   
						   
						
						SELECT @nc1=Field32, @nc2=Field33, @nc3=Field34 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field32, Field33,Field34 
										from #TmpTable1
										
						   end
						   
						   
						SELECT @nc1=Field36, @nc2=Field37, @nc3=Field38 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field36, Field37,Field38 
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field40, @nc2=Field41, @nc3=Field42 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field40, Field41,Field42 
										from #TmpTable1
										
						   end
						   
						SELECT @nc1=Field44, @nc2=Field45, @nc3=Field46 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field44, Field45,Field46 
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field48, @nc2=Field49, @nc3=Field50 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field48, Field49,Field50
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field52, @nc2=Field53, @nc3=Field54 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field52, Field53,Field54
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field56, @nc2=Field57, @nc3=Field58 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field56, Field57,Field58
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field60, @nc2=Field61, @nc3=Field62 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field60, Field61,Field62
										from #TmpTable1
										
						   end
						
						SELECT @nc1=Field64, @nc2=Field65, @nc3=Field66 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field64, Field65,Field66
										from #TmpTable1
										
						   end
						
						
						SELECT @nc1=Field68, @nc2=Field69, @nc3=Field70 from #TmpTable1
						if (@nc1 <>'' and @nc1<>'' and @nc3<>'')
						   begin
						   insert into #Tmpcollect1 (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
										select CASE WHEN ISNumeric(Field2)=1 THEN dbo.getStudentUIDFromPhoneNo(cast(Field2 as decimal(15))) ELSE 0 END as OwnerUID, Field3, Field4, Field15, Field68, Field69,Field70
										from #TmpTable1
										
						   end
										
						--select * 
						--into #collectScore
						--from #TmpCollect						
						
						
						
						
						
						
						
						insert into #collectScore (OwnerUID, Field3, Field4, Field15, Field28, Field29, Field30)
						select * from #TmpCollect1
						
						drop table #TmpCollect1
						Drop table #TmpTable1
				 END
				 set @CPass=@CPass+1

			
	       
				   FETCH NEXT FROM db_cursor INTO  @name1
			END   

			CLOSE db_cursor   
			DEALLOCATE db_cursor

 
			  Exec dbo.GenerateSScoreBatch

			  insert into dbo.testScoreBatch 
				select OwnerUID, Field3 as Lastname, Field4 as Firstname, LEFT(CONVERT(VARCHAR, Field15, 120), 10) as TestDate, Field28 as TestName, Field29 as Score1, 
					   Field30 as Percentile, 0 as Authorized , dbo.getSScoreBatchNum() as BNum
					   from #collectScore


			DECLARE @AlertMode int

			set @AlertMode=0

			if (@AlertMode=0)
				BEGIN


						declare @topic varchar(300)
						declare @tbody varchar(300)
						set @topic='Test Score Batch ready as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
						set @tbody= '<p>Dear Test Administrator, </p>'+'<p>The Batch is ready , please review and authorize the score by clicking on the link below: </p>'+
								'<p>https://ecams.trocaire.edu/efaculty/cePortalMatrixAuthTestScore.asp</p>'+'<p>Regards, </p>'+'<p>Senghor E </p>'



							-- Send an email
							EXEC msdb.dbo.sp_send_dbmail 
							@profile_name='TROCMAIL',
							@recipients = 'etiennes@trocaire.edu', 
							@subject = @topic ,
							@body = @tbody ,
							@body_format = 'HTML';  
				END
				
			if (@AlertMode=1)
				BEGIN

						-- select OwnerUID, TestDate , TestName, Score1, Percentile, Authorized, BNum  from dbo.testScoreBatch 
					    
						update dbo.testscorebatch set Authorized=1 --where owneruid=123838
						where Authorized=0 and (owneruid is not null and owneruid >0)
			    
			    
			    
									declare @name2 varchar(50)
									declare @name3 varchar(50)
									declare @name4 varchar(50)
									declare @name5 varchar(50)
									declare @name6 varchar(50)
									declare @name7 varchar(50)


											DECLARE db_cursor1 CURSOR FOR  
												select OwnerUID, TestDate, TestName, Score1, Percentile, Authorized 
												from dbo.testScoreBatch 
												where Authorized=1 and (owneruid is not null and owneruid >0)
												--where owneruid=123838
												
												OPEN db_cursor1
												FETCH NEXT FROM db_cursor1 INTO @name2, @name3, @name4, @name5, @name6, @name7

												WHILE @@FETCH_STATUS = 0   
												BEGIN   
													Exec dbo.InsertStudentScoresFromAccOrg @name2,  @name3,  @name4,  @name5,  @name6, @name7


													   FETCH NEXT FROM db_cursor1 INTO   @name2, @name3, @name4, @name5, @name6, @name7
												END   

												CLOSE db_cursor1  
											DEALLOCATE db_cursor1


											--Direct Upload Email
							
											declare @topic1 varchar(300)
											declare @tbody1 varchar(300)
											set @topic1='Student Scores Uploaded as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
											set @tbody1= '<p>Dear Test Administrator, </p>'+'<p>The Following Student Scores have been uploaded into their respective Student Account: </p>'+
											'Please, see attached file. '+'<p>Regards, </p>'+'<p>Senghor E </p>'

										
											DECLARE @cmdstr varchar(2500)
											DECLARE @tmstp varchar(15)
											DECLARE @globalcmdstr varchar(2500)
											DECLARE @filename1 varchar(300)
											DECLARE @filename2 varchar(300)
											DECLARE @Qry1 varchar(300)
											DECLARE @Qry2 varchar(300)
											
												-- Matched Students
												
												set @Qry1='select * from CAMS_Enterprise.dbo.testScoreBatch where authorized =1 and BNum=CAMS_Enterprise.dbo.getSScoreBatchNum()'
												
												set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on;'+@Qry1+'"  > D:\CAMSEnterprise\SScores\ScoreFile'
												--print  @cmdstr
												set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
												set @globalcmdstr = @cmdstr+'_'+@tmstp+'_'+cast (dbo.getSScoreBatchNum() as varchar) +'.csv'
												set @filename1='D:\CAMSEnterprise\SScores\ScoreFile_'+@tmstp+'_'+cast (dbo.getSScoreBatchNum() as varchar) +'.csv'
												print @globalcmdstr
												EXEC  master..xp_cmdshell @globalcmdstr
												
												-- UnMatched Students Not Uploaded
												
												set @Qry2='select * from CAMS_Enterprise.dbo.testScoreBatch where authorized =0 and BNum=CAMS_Enterprise.dbo.getSScoreBatchNum()'
												
												set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "SET ANSI_WARNINGS OFF; set nocount on;'+@Qry2+'"  > D:\CAMSEnterprise\SScores\UnMatched_ScoreFile'
												--print  @cmdstr
												set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
												set @globalcmdstr = @cmdstr+'_'+@tmstp+'_'+cast (dbo.getSScoreBatchNum() as varchar) +'.csv'
												set @filename2='D:\CAMSEnterprise\SScores\UnMatched_ScoreFile_'+@tmstp+'_'+cast (dbo.getSScoreBatchNum() as varchar) +'.csv'
												print @globalcmdstr
												EXEC  master..xp_cmdshell @globalcmdstr
												

															
											declare @glfile varchar(max)
											--set @glfile=@filename1
											set @glfile=@filename1+ ';'+@filename2
											
													
											-- Send an email
											EXEC msdb.dbo.sp_send_dbmail 
											@profile_name='TROCMAIL',
											@recipients = 'etiennes@trocaire.edu', 
											@file_attachments =@glfile,
											@subject = @topic1 ,
											@body = @tbody1 ,
											@body_format = 'HTML';   

											EXEC  master..xp_cmdshell 'del D:\CAMSEnterprise\SScores\*ScoreFile*.*'
				
				END
						
			-----------



    --select * from CAMS_TestScore
    --select * from CAMS_Test where CAMS_TestRefID=12
    
	--select * from CAMS_TestScore1
   -- select * from CAMS_Test1 where CAMS_TestRefID=12
    

    
    --select * from CAMS_TestRef where TestName='Accuplacer'
    --select * from CAMS_TestScoreRef

 


Drop table #tmpDirectory
Drop table #ExamFiles
Drop table #collectScore



