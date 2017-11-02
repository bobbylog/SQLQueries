drop table #Tmptab

DECLARE @BaID bigint
DECLARE @Tm int

set @Tm=616 


insert into dbo.BatchMaster(BatchName, UserID, CampusID,Comment, TransactionNo, SourceModuleID, TermBased, DepartmentID)
values('RFUNDS-CAMS-'+cast(MONTH(GETDATE()) as varchar)+'-'+cast(DAY(GETDATE()) as varchar)+'-'+cast(YEAR(GETDATE()) as varchar),'TCCAMSMGR',0,'Student Refunds FA-17',0,2,1,0)

select top 1 @BaID=BatchMasterID from dbo.BatchMaster 
where BatchName=('RFUNDS-CAMS-'+cast(MONTH(GETDATE()) as varchar)+'-'+cast(DAY(GETDATE()) as varchar)+'-'+cast(YEAR(GETDATE()) as varchar))




								
create table #TmpTab(
	Term varchar(25),
	StudentID varchar(25),
	LastName varchar(25),
	FirstName varchar(25),
	MiddleName varchar(25),
	TotalDebits numeric(8,2),
	TotalCredits numeric(8,2),
	PreviousBalance numeric(8,2),
	StatementTotal numeric(8,2),
	Pending numeric(8,2),
	OvrAllTotal numeric(8,2),
	RefundAmount numeric(8,2),
	Category varchar(25)

)

insert into #TmpTab
EXEC [dbo].[TCC_Refund_Report_By_Term]'fa-17','SCR'

select * from #TmpTab
Where RefundAmount<0

DECLARE @name1 datetime
DECLARE @name2 varchar(25)
DECLARE @name3 varchar(25)
DECLARE @name4 varchar(25)
DECLARE @name5 varchar(25)
DECLARE @name6 varchar(25)
DECLARE @name7 numeric(8,2)
DECLARE @name8 datetime

DECLARE db_cursor CURSOR FOR  
	select StudentID as Field4,  'IN' as Field6, (-1 * refundAmount) as Field7, GETDATE() as Field8  
	from #Tmptab Where RefundAmount<0
											 
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
			173, 
			case @name6 when 'IN' then 'DEBIT' else 'CREDIT' end ,
			isnull(dbo.getstudentUIDFromID(ltrim(rtrim(@name4))),0), 
			'CAMS Button Refund (CBR)', 
			isnull(CAST (@name7 as numeric(8,2)),0),
			case @name6 when 'IN' then 1 else -1 end, 
			case @name6 when 'IN' then isnull(CAST (@name7 as numeric(8,2)),0) else -1 * isnull(CAST (@name7 as numeric(8,2)),0) end ,
				case @name6 when 'IN' then isnull(CAST (@name7 as numeric(8,2)),0) else 0 end, 
			case @name6 when 'IN' then 0 else isnull(CAST (@name7 as numeric(8,2)),0) end ,
			0,
			'TCCAMSMGR', 
			GETDATE(),0,0,0,0,0,'','' )
														
			--set @rc1=@@ROWCOUNT
			--set @rc=@rc+@rc1

		FETCH NEXT FROM db_cursor INTO @name4, @name6, @name7, @name8
END   

CLOSE db_cursor   
DEALLOCATE db_cursor




 --select Field4=studentuid,  
 --Field6 =transtype, 
 --Field7 = Amount , 
 --Field8 =Transdate
 -- from #Tmptab

								


drop table #Tmptab