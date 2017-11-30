USE [CAMS_Enterprise]


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

DECLARE @tid int
DECLARE @tsqc varchar(25)
DECLARE @TStDate varchar(25)
DECLARE @TEndDate varchar(25)

set @TStDate='07/17/2017' 
set @TEndDate='10/28/2017'
set @tid=616
set @tsqc='B17Q'

-- Getting List of Student IDS
Select Distinct Bill.OwnerUID INTO #TCCAMSMGRID From Billing Bill INNER JOIN TransDoc ON Bill.TransDocID = TransDoc.TransDocID 
INNER JOIN Student ON Bill.OwnerUID = Student.StudentUID WHERE ((TransDoc.ReportFlag = 'Yes') OR (TransDoc.ReportFlag = '')) AND (Bill.TermCalendarID = @tid)  
AND ((Bill.Voided = 'No') OR (Bill.Voided = '')) AND ((Bill.Reversing = 'No') OR (Bill.Reversing = ''))

Insert INTO #TCCAMSMGRID ( OwnerUID ) Select Bill.OwnerUID From BillingBatch Bill 
Inner Join TransDoc ON Bill.TransDOCID = TransDoc.TransDocID INNER JOIN Student ON Bill.OwnerUID = Student.StudentUID WHERE Bill.OwnerUID 
NOT IN (Select OwnerUID From #TCCAMSMGRID) AND (Bill.TermCalendarID = @tid) 


Select Distinct * Into #TCCAMSMGRIDPRE From #TCCAMSMGRID

Select * Into #TCCAMSMGRIDPRE2 From #TCCAMSMGRIDPRE

Delete from #TCCAMSMGRIDPRE

INSERT INTO #TCCAMSMGRIDPRE 
Select Distinct A.OwnerUID From #TCCAMSMGRIDPRE2 A Inner Join Student as STU ON A.OwnerUID = STU.StudentUID 
where STU.TypeID<>2638 and Stu.ProspectStatusID not in (9,10,11)


-- Getting Billing Details

Select A.* Into #TCCAMSMGRDetail From CAMS_BillingLedgerStmtRpt_View A 
Inner Join #TCCAMSMGRIDPRE as TMP on A.OwnerUID = TMP.OwnerUID 
Where (A.TermCalendarID = @tid) 

 UNION ALL 
Select B.* From CAMS_BillingBatchStmtRpt_View B 
Inner Join #TCCAMSMGRIDPRE as TMP1 ON B.OwnerUID = TMP1.OwnerUID 
Where (B.TermCalendarID = @tid) 


 UNION ALL 
Select C.* From CAMS_FinAidPending_View C 
Inner Join #TCCAMSMGRIDPRE as TMP2 On C.OwnerUID = TMP2.OwnerUID 
Where (C.Term = @tsqc)

--select * from #TCCAMSMGRDetail

-- Compute Previous Balance

Select A.OwnerUID, Sum(Bill.ShowAmount) as 'PreviousBalance', 0 as 'TotalPending' into #TCCAMSMGRIDPREPrevBal 
From #TCCAMSMGRIDPRE A Left Outer Join Billing as BILL ON A.OwnerUID = BILL.OwnerUID Inner JOIN TransDoc ON BILL.TransDocID = TransDoc.TransDOCID 
Inner Join TermCalendar as TC ON BILL.TermCalendarID = TC.TermCalendarID WHERE ((TransDoc.ReportFlag = 'Yes') 
Or (TransDoc.ReportFlag = ''))  AND (TC.Term < @tsqc) AND (BILL.Voided IN ('No','')) 
AND (BILL.Reversing IN ('No','')) GROUP BY A.OwnerUID UNION ALL Select A.OwnerUID, Sum(Bill.ShowAmount) as 'PreviousBalance', 0 as 'TotalPending'  
From #TCCAMSMGRIDPRE A Left Outer Join BillingBatch as BILL ON A.OwnerUID = BILL.OwnerUID Inner JOIN TransDoc ON BILL.TransDocID = TransDoc.TransDOCID 
Inner Join TermCalendar as TC ON BILL.TermCalendarID = TC.TermCalendarID WHERE ((TransDoc.ReportFlag = 'Yes') Or (TransDoc.ReportFlag = ''))  
AND (TC.Term < @tsqc)  GROUP BY A.OwnerUID  UNION ALL Select A.OwnerUID, 0 As 'PreviousBalance', Sum(FIN.EstimatedAmount) AS 'TotalPending' 
From #TCCAMSMGRIDPRE A Left Outer Join FinancialAward as FIN ON A.OwnerUID = FIN.StudentUID Where (FIN.ShowOnBillingStatement = 'Yes') 
AND (FIN.BillingBatchName = '')  AND (FIN.TermCalendarID = @tid) Group By A.OwnerUID



Select Distinct A.OwnerUID, Sum(A.PreviousBalance) AS 'PreviousBalance', Sum(A.TotalPending) As 'TotalPending'  
Into #TmpPreBalanceTCCAMSMGR From #TCCAMSMGRIDPREPrevBal A GROUP BY A.OwnerUID



-- Prepare Entire Statement

Select Distinct A.OwnerUID as OwnerUIDx, A.*, B.PreviousBalance, B.TotalPending 
Into #TCCAMSMGR_STMTS From #TCCAMSMGRDetail A  LEFT OUTER JOIN #TmpPreBalanceTCCAMSMGR B ON A.OwnerUID = B.OwnerUID 
UNION
Select Distinct B.OwnerUID as OwnerUIDx, A.*, B.PreviousBalance, B.TotalPending  
From #TmpPreBalanceTCCAMSMGR B  LEFT OUTER JOIN #TCCAMSMGRDetail A ON B.OwnerUID = A.OwnerUID 

-- Compute Aging

Exec CAMS_StudentBillingAgingbyDays '12/12/2017', 9999999, 'No','', '#TCCAMSMGRIDPRE', 'TCCAMSMGR_AgingByDays'

-- Display Statement Result



Select Distinct A.StudentID, A.LastName,A.FirstName,A.MiddleName, isnull((sum(B.Debits)),0) as TotalDebits, 
(isnull((sum(B.Credits)),0)-isnull(B.TotalPending,0)) as TotalCredits, 
isnull(B.PreviousBalance,0) as PreviousBalance ,
isnull(B.TotalPending,0) as Pending
--, 
--isnull ((sum(B.Debits)-(sum(B.Credits)-B.TotalPending)),0) As StatementTotal, 
--isnull (-((-(sum(B.Debits)- (sum(B.Credits)-B.TotalPending) -B.TotalPending+B.PreviousBalance ))),0) As OvrAllTotal

into #BillingStmtSummary
From CAMS_StudentRptBillingStatement_View as A LEFT OUTER JOIN #TCCAMSMGR_STMTS AS B ON A.StudentUID = B.OwnerUIDx 
LEFT OUTER JOIN TCCAMSMGR_AgingByDays as D ON A.StudentUID = D.StudentUID 
INNER JOIN #TCCAMSMGRIDPRE AS C ON A.StudentUID = C.OwnerUID WHERE (A.AddressType = 'Billing') AND (A.ActiveFlag = 'Yes') 
--AND A.LastName='Harris'
group by A.StudentID, A.LastName,A.FirstName,A.MiddleName, B.PreviousBalance,B.TotalPending, A.StudentUID


--Select Distinct A.StudentID, A.LastName,A.FirstName,A.MiddleName, B.Debits, B.Credits, isnull(B.PreviousBalance,0) as PreviousBalance ,isnull(B.TotalPending,0) as Pending,isnull (((-(sum(B.Debits)- sum(B.Credits)+B.PreviousBalance))),0) As OvrAllTotal
--into #BillingStmtSummary1
--From CAMS_StudentRptBillingStatement_View as A LEFT OUTER JOIN #TCCAMSMGR_STMTS AS B ON A.StudentUID = B.OwnerUIDx 
--LEFT OUTER JOIN TCCAMSMGR_AgingByDays as D ON A.StudentUID = D.StudentUID 
--INNER JOIN #TCCAMSMGRIDPRE AS C ON A.StudentUID = C.OwnerUID WHERE (A.AddressType = 'Billing') AND (A.ActiveFlag = 'Yes') 
--group by A.StudentID, A.LastName,A.FirstName,A.MiddleName, B.Debits, B.Credits, B.PreviousBalance, B.TotalPending, A.StudentUID


select  StudentID,LastName, FirstName, MiddleName, TotalDebits, TotalCredits, PreviousBalance,  
(TotalDebits-TotalCredits) as StatementTotal,
Pending,
((TotalDebits-TotalCredits)-Pending+PreviousBalance) as OvrAllTotal
--, 
--case when PreviousBalance > 0 
--then ((TotalDebits-TotalCredits)-Pending+PreviousBalance)
--else (TotalDebits-TotalCredits) end as RefundAmount 
into #BillingStmtSummary1
from #BillingStmtSummary order by LastName asc



select top 10
StudentID,LastName, FirstName, MiddleName, TotalDebits, TotalCredits, PreviousBalance,  
StatementTotal,Pending, OvrAllTotal,  (StatementTotal-PreviousBalance) as RefundAmount
from #BillingStmtSummary1
where 
--LastName like 's%'
StudentID='A0000019318'
order by studentID asc



--Select Distinct A.StudentID, (sum(B.Debits)) As Amount
--into #BillingDebits
--From CAMS_StudentRptBillingStatement_View as A LEFT OUTER JOIN #TCCAMSMGR_STMTS AS B ON A.StudentUID = B.OwnerUIDx 
--LEFT OUTER JOIN TCCAMSMGR_AgingByDays as D ON A.StudentUID = D.StudentUID 
--INNER JOIN #TCCAMSMGRIDPRE AS C ON A.StudentUID = C.OwnerUID WHERE (A.AddressType = 'Billing') AND (A.ActiveFlag = 'Yes') 
--AND B.TransDoc='BNBOOKS' 
---- B.Description like 'bookstore%'
--group by A.StudentID, A.LastName,A.FirstName,A.MiddleName, B.PreviousBalance, A.StudentUID


--select BSS.StudentID, BSS.LastName,BSS.FirstName,BSS.MiddleName, BSS.Amount , isnull((select sum(ex.amount) as totala from #BillingDebits ex where ex.StudentID=BSS.StudentID group by ex.studentid),'0') as expenses ,BSS.ProviderCode, BSS.BeginDate, BSS.EndDate, BSS.IDType, BSS.RecordType, BSS.AccountType, BSS.StudHold
--into #TmpBillingStmtSummary
--from  #BillingStmtSummary BSS
--where (BSS.Amount > 0)
----and (BSS.StudHold=0)
--order by BSS.LastName

--select StudentID, LastName, FirstName, MiddleName, ( Amount+ Expenses )  as TmpAmount, 
--ProviderCode, BeginDate, EndDate, IDType, RecordType, AccountType , StudHold
--into #FinalBillingStmtSummary
--from 
--#TmpBillingStmtSummary


--select StudentID, LastName, FirstName, MiddleName,case StudHold when 0 then  replace(cast(TmpAmount as varchar(10)),'.','') else replace('0.01','.','') end as Amount, 
--ProviderCode, BeginDate, EndDate, IDType, RecordType, AccountType 
--from 
--#FinalBillingStmtSummary


drop table #TCCAMSMGR_STMTS 
drop table #TCCAMSMGRIDPREPrevBal
--drop table #TCCAMSMGRIDPREBal
drop table #TmpPreBalanceTCCAMSMGR
drop table  #TCCAMSMGRID
drop table #TCCAMSMGRDetail
Drop Table #TCCAMSMGRIDPRE
Drop Table #TCCAMSMGRIDPRE2
drop table  #BillingStmtSummary
drop table #FinalBillingStmtSummary
drop table #TmpBillingStmtSummary
drop table  #BillingDebits
drop table #BillingStmtSummary1


