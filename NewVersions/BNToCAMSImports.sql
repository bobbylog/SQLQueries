Use CAMS_enterprise
drop table #tmptable
drop table #tmpret

 Declare @BaID bigint
 Declare @Tm int
 
 set @Tm=614
 
 EXEC  master..xp_cmdshell 'echo Field1,Field2,Field3,Field4,Field5,Field6,Field7 > d:\sftp\barnes_noble\imports\TransactionsProcessed.csv'
 EXEC  master..xp_cmdshell 'type d:\sftp\barnes_noble\imports\FromBNCBData.csv >> d:\sftp\barnes_noble\imports\TransactionsProcessed.csv'
 
 select * --, GETDATE() as DateCollected
 into #TmpTable
from openrowset('MSDASQL'
 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
 DefaultDir=D:\SFTP\barnes_noble\Imports\' 
 ,'select * from "TransactionsProcessed.csv"') T

 --drop table #Tmpret
 
 select Field1, Field2, Field3, Field4, Field5, reverse (stuff(REVERSE(Field6),3,0,'.')) as ExpFld, Field7 
 into #TmpRet
 from #TmpTable
 

 
 
 insert into dbo.BatchMaster(BatchName, UserID, CampusID,Comment, TransactionNo, SourceModuleID, TermBased, DepartmentID)
	values('BN-ONLINE-'+cast(MONTH(GETDATE()) as varchar)+'-'+cast(DAY(GETDATE()) as varchar)+'-'+cast(YEAR(GETDATE()) as varchar),'TCCAMSMGR',0,'Online B And N Transactions',0,2,1,0)

select top 1 @BaID=BatchMasterID from dbo.BatchMaster 
where BatchName=('BN-ONLINE-'+cast(MONTH(GETDATE()) as varchar)+'-'+cast(DAY(GETDATE()) as varchar)+'-'+cast(YEAR(GETDATE()) as varchar))

	DECLARE @name1 datetime
	DECLARE @name2 varchar(25)
	DECLARE @name3 varchar(25)
	DECLARE @name4 varchar(25)
	DECLARE @name5 varchar(25)
	DECLARE @name6 varchar(25)
	DECLARE @name7 varchar(25)

	
				DECLARE db_cursor CURSOR FOR  
				 select Field1, Field2, Field3, Field4, Field5, ExpFld, Field7  from #TmpRet
				

				OPEN db_cursor   
				FETCH NEXT FROM db_cursor INTO @name1 , @name2, @name3, @name4, @name5, @name6, @name7

				WHILE @@FETCH_STATUS = 0   
				BEGIN   
					   
				     
					insert into BillingBatch (BatchMasterID,TermCalendarID,TransDate,TransdocID,TransType,OwnerUID, Description, 
							Amount,AmountFactor,ShowAmount, Debits, Credits,ARTypeID,InsertUserID, InsertTime,
							RefNo,ExtTypeId, CreditCardNum,CreditCardTypeID, A1098Deductible,UpdateUserID,DirectDepositBatch)
							VALUES
							(
							@BaID, 
							@Tm, 
							@name1, 
							418, 
							case @name7 when 'IN' then 'DEBIT' else 'CREDITS' end ,
							dbo.getstudentUIDFromID(@name4), 
							'BookStore Charges (BNA)', 
							CAST (@name6 as numeric(5,2)),
							case @name7 when 'IN' then 1 else -1 end, 
							case @name7 when 'IN' then CAST (@name6 as numeric(5,2)) else -1 * CAST (@name6 as numeric(5,2)) end ,
							 case @name7 when 'IN' then CAST (@name6 as numeric(5,2)) else 0 end, 
							case @name7 when 'IN' then 0 else CAST (@name6 as numeric(5,2)) end ,
							0,
							'TCCAMSMGR', 
							GETDATE(),0,0,0,0,0,'','' )

					   FETCH NEXT FROM db_cursor INTO @name1 , @name2, @name3, @name4, @name5, @name6, @name7
				END   

				CLOSE db_cursor   
				DEALLOCATE db_cursor
	
		
	
drop table #TmpTable
drop table #TmpRet

