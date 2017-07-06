--EXEC [dbo].[TCC_getAlphaThetaKappaStudents] 'sp-17','109','616','1.0','9.0'
--EXEC [dbo].[TCC_getAlphaThetaKappaStudents] 'sp-17','152','616','1.0','9.0'
	
--drop table #PhiThetaList
declare @name1 int
declare @Cpass int
declare @name2 varchar (200)

set @Cpass=1

			DECLARE db_cursor1 CURSOR FOR  
				SELECT distinct MM.MajorMinorID, MM.MajorMinorName
				FROM CAMS_Enterprise.dbo.MajorMinor MM
				WHERE MM.ActiveMajor = 1 AND NOT MajorMinorName = ''
				
				
				OPEN db_cursor1   
				FETCH NEXT FROM db_cursor1 INTO @name1, @name2

				WHILE @@FETCH_STATUS = 0   
				BEGIN   
					
				EXEC [dbo].[TCC_getAlphaThetaKappaStudents2] 'sp-17',@name1, @name2 ,'1.0','9.0'
		        
		        
		         if @Cpass = 1 
		        begin
					select *
					into #PhiThetaList
					from dbo.PhithetaKappaRpt
		        end
		        
		        if @Cpass > 1 
		        begin
					insert into #PhiThetaList
					select *
					from dbo.PhithetaKappaRpt
		        end
		        
		       
		        
		         set @Cpass=@Cpass+1
		         
					   FETCH NEXT FROM db_cursor1 INTO  @name1, @name2
				END   

				CLOSE db_cursor1 
				 
			DEALLOCATE db_cursor1

	-- put back 124 rad tech later

	select * from  #PhiThetaList
	where StudentMajor not in (152,136, 135, 155)
	and honorsid2 <>2444
	and ExpectedTermID <> dbo.getTermID(dbo.getcurrentTerm())
	
	drop table #PhiThetaList
	