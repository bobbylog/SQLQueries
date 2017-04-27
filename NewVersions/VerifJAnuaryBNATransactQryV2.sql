
drop table #tmp4
drop table #JBN
drop table #tmp3
drop table #tmp1
drop table #tmp2
--drop table #tmptab
--drop table #NE
--drop table #NE1
drop table #TmpBN

SELECT 
DISTINCT 
               TOP (100) PERCENT A.custname, A.StudentID, A.Amt, A.TransDate, A.InvoiceDate, case when A.Amt < 0 then 'CREDIT' else 'DEBIT' end as Transtype
               --, B.TransDate AS TransDateB, B.TransType, B.Description, B.ShowAmount
               into #TmpBN
FROM  dbo.JanCollectBN AS A 

select *,

[dbo].[getVerifiedStuLedgerAmount] (
 dbo.getStudentUIDFromID(StudentID),
 1,
 TransType,
 TransDate,
 Amt
 
) as CAMSLedgerAmt 
 into #Tmp1
 from #TmpBN
 
 
 
select *,

[dbo].[getVerifiedStuLedgerAmount] (
 dbo.getStudentUIDFromID(StudentID),
 1,
 TransType,
 InvoiceDate,
 Amt
 
) as CAMSLedgerAmt 

into #tmp2
 from #TmpBN

select * 
into #tmp3
from #Tmp1 where CAMSLedgerAmt is not null
union
select * from #tmp2 where CAMSLedgerAmt is not null

select * , case when Amt < 0 then 'CREDIT' ELSE 'DEBIT' END as Transtype
into #JBN
from dbo.JanCollectBN

select distinct A1.studentID as StrudentIDA, A1.custname as custa, A1.Transtype as Transta, A1.TransDate as transdta,a1.Amt as amta, B.* 
into #tmp4
from #JBN A1
left outer join
#tmp3 B
ON 
          A1.Amt = B.Amt
          AND A1.StudentID = B.StudentID
          AND A1.TransDate = B.TransDate 
          AND A1.transtype=b.transtype
--order by A1.TransDate,A1.StudentID
select * from #tmp4 
--where CAMSLedgerAmt is null


drop table #tmp4
drop table #JBN
drop table #tmp3
drop table #tmp1
drop table #tmp2
--drop table #tmptab
--drop table #NE
--drop table #NE1
drop table #TmpBN
