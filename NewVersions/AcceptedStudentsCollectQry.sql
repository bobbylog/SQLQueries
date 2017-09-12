Use CAMS_enterprise
 drop table #tmpAcceptedTab

DECLARE @nc int

--EXEC  master..xp_cmdshell 'type D:\CAMSEnterprise\AccImports\MailMerge*.csv >> D:\CAMSEnterprise\AccImports\MailMerge.csv'

--Insert into CAMS_Liaison_Inquiries
select Atype as BatchID, GETDATE() as DateCollected, 'FA-17' as Term, *
, dbo.isStudentCollected(Studentid,'FA-17') as CollectStatus
into #tmpAcceptedTab
from openrowset('MSDASQL'
 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
 DefaultDir=D:\CAMSEnterprise\AccImports\' 
 ,'select * from "MailMerge.csv"') T

 delete from #tmpAcceptedTab where BatchID='-----'
 set @nc=(select count(StudentID) from #tmpAcceptedTab)

 if @nc >0 
 --   delete from CTM_AcceptedStudentsBatch 
	--where 
	--Month(DateCollected)=Month(GETDATE()) 
	--and Day(DateCollected)=Day(GETDATE()) 
	--and Year(DateCollected)=Year(GETDATE()) 

	
								DECLARE @name1 varchar(25)
								DECLARE @name2 varchar(25)
								DECLARE @name3 varchar(25)
								DECLARE @name4 varchar(25)
								DECLARE @name5 varchar(25)
								DECLARE @name6 varchar(25)
								DECLARE @name7 varchar(25)
								DECLARE @name8 varchar(25)
								DECLARE @name9 varchar(25)
								DECLARE @name10 varchar(25)
								
											DECLARE db_cursor CURSOR FOR  
											 select StudentID, LastName, FirstName, MiddleInitial, UserID, Npassword, Password, Address, CSZ, CollectStatus
											 From #tmpAcceptedTab
											 --where itemStatus='include'
											 
											OPEN db_cursor   
											FETCH NEXT FROM db_cursor INTO @name1, @name2, @name3, @name4, @name5, @name6, @name7, @name8, @name9, @name10

											WHILE @@FETCH_STATUS = 0   
											BEGIN   
												   --print  @name4
										       
											      if @name10=1
												  begin
													update  [dbo].[CTM_AcceptedStudentsBatch] set
														LastName=@name2,
														FirstName=@name3,
														MiddleInitial=@name4,
														UserID=@name5,
														NPassword=@name6,
														Password=@name7,
														Address=@name8,
														CSZ=@name9
													Where StudentID=@name1 and Term='FA-17'
												  end

												  if @name10=0
												  begin
													  Insert into CTM_AcceptedStudentsBatch
													  (BatchID, DateCollected, Term,LastName,FirstName,MiddleInitial,UserID,Npassword,Password,ATYPE,Address,CSZ)
														select BatchID, DateCollected, Term,LastName,FirstName,MiddleInitial,UserID,Npassword,Password,ATYPE,Address,CSZ 
														from #tmpAcceptedTab where Studentid=@name1 and term='FA-17'
														-- and itemStatus='include'

												  end
														
													
												   FETCH NEXT FROM db_cursor INTO @name1, @name2, @name3, @name4, @name5, @name6, @name7, @name8, @name9, @name10
											END   

											CLOSE db_cursor   
											DEALLOCATE db_cursor
										

    --Insert into CTM_AcceptedStudentsBatch
	--select * from #tmpAcceptedTab
	delete from CTM_AcceptedStudentsBatch where itemStatus='exclude' and term='FA-17'

	select * from CTM_AcceptedStudentsBatch

	EXEC  master..xp_cmdshell 'del /F /Q D:\CAMSEnterprise\AccImports\MailMerge.*'

 drop table #tmpAcceptedTab