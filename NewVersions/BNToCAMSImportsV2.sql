Use CAMS_enterprise
--drop table #tmptable
--drop table #tmpret
--drop table #tmp

 Declare @BaID bigint
 Declare @Tm int
 DEclare @nc1 int
 Declare @nt bigint
 Declare @tnc bigint
 DEclare @pfld varchar(100)
 DEclare @rfld varchar(100)
 DEclare @cmd1 varchar(350)
 DEclare @cmd2 varchar(350)
 
 set @tnc=0
 set @nt=0
 set @Tm=614
 
 set @rfld='SU17\Raw\'
 set @pfld='SU17\Processed\'
 
 set @cmd1=  'copy d:\sftp\barnes_noble\imports\AR*V3.csv d:\sftp\barnes_noble\imports\Archives\'+@rfld
								
 
 
 EXEC  master..xp_cmdshell 'echo Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 > d:\sftp\barnes_noble\imports\TransactionsProcessed.csv'
 
 EXEC  master..xp_cmdshell @cmd1
 EXEC  master..xp_cmdshell 'move d:\sftp\barnes_noble\imports\AR*V3.csv d:\sftp\barnes_noble\imports\FromBNCBData.csv'
 EXEC  master..xp_cmdshell 'type d:\sftp\barnes_noble\imports\FromBNCBData.csv >> d:\sftp\barnes_noble\imports\TransactionsProcessed.csv'
 
 select * --, GETDATE() as DateCollected
  into #TmpTable
from openrowset('MSDASQL'
 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
 DefaultDir=D:\SFTP\barnes_noble\Imports\' 
,'select * from TransactionsProcessed.csv') T

--select * from #TmpTable

select distinct @nt=Field2 from #TmpTable
select @nc1=count(Field2) from #TmpTable

select @tnc=count(Transnum) from dbo.BN_Transmissions_History
where Transnum=@nt

if (@tnc=0) and (@nc1 >0)
	begin
	
			insert into dbo.BN_Transmissions_History(Transnum) values (@nt)

				 select Field1, Field2, Field3, Field4, Field5, Field6, reverse (stuff(REVERSE(Field7),3,0,'.')) as Field71, Field8, Field9
				 into #Tmp
				 from #TmpTable


		-- select Field4, Field6, Field71 as Field7, Field8
		-- into #TmpRet
		-- from #Tmp
		 
		 select Field4, Field6, sum(cast (Field71 as numeric (5,2))) as FL7 , Field8
		 into #TmpRet1
		 from #Tmp
		 group by  Field8, Field4, Field6
		 
		 select Field4, Field6, cast (FL7 as varchar) as Field7 , Field8
		 into #TmpRet
		 from #TmpRet1

		--select * from #TmpRet

		DECLARE @nc int

		select @nc=COUNT(Field4) from #TmpRet 

				if (@nc > 0)
					begin

							 
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
								DECLARE @name8 datetime

								
											DECLARE db_cursor CURSOR FOR  
											 select Field4,  Field6, Field7, Field8  from #TmpRet
											

											OPEN db_cursor   
											FETCH NEXT FROM db_cursor INTO @name4, @name6, @name7, @name8

											WHILE @@FETCH_STATUS = 0   
											BEGIN   
												   --print  @name4
												 --select dbo.getstudentUIDFromID (rtrim(ltrim(cast(@name4 as varchar))))
											     
												insert into BillingBatch (BatchMasterID,TermCalendarID,TransDate,TransdocID,TransType,OwnerUID, Description, 
														Amount,AmountFactor,ShowAmount, Debits, Credits,ARTypeID,InsertUserID, InsertTime,
														RefNo,ExtTypeId, CreditCardNum,CreditCardTypeID, A1098Deductible,UpdateUserID,DirectDepositBatch)
														VALUES
														(
														@BaID, 
														@Tm, 
														@name8, 
														418, 
														case @name6 when 'IN' then 'DEBIT' else 'CREDIT' end ,
														dbo.getstudentUIDFromID(ltrim(rtrim(@name4))), 
														'BookStore Charges (BNA)', 
														CAST (@name7 as numeric(5,2)),
														case @name6 when 'IN' then 1 else -1 end, 
														case @name6 when 'IN' then CAST (@name7 as numeric(5,2)) else -1 * CAST (@name7 as numeric(5,2)) end ,
														 case @name6 when 'IN' then CAST (@name7 as numeric(5,2)) else 0 end, 
														case @name6 when 'IN' then 0 else CAST (@name7 as numeric(5,2)) end ,
														0,
														'TCCAMSMGR', 
														GETDATE(),0,0,0,0,0,'','' )

												   FETCH NEXT FROM db_cursor INTO @name4, @name6, @name7, @name8
											END   

											CLOSE db_cursor   
											DEALLOCATE db_cursor
										
											set @cmd2= 'Move d:\sftp\barnes_noble\imports\FromBNCBData.csv d:\sftp\barnes_noble\imports\Archives\'+@pfld+'FromBNCBData'+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+'.csv'
											EXEC  master..xp_cmdshell @cmd2
											EXEC  master..xp_cmdshell 'echo Field1,Field2,Field3,Field4,Field5,Field6,Field7,Field8,Field9 > d:\sftp\barnes_noble\imports\TransactionsProcessed.csv'
						
						
											drop table #TmpRet1
											drop table #TmpRet
											drop table #Tmp
									 
						end		


		
end

drop table #TmpTable
