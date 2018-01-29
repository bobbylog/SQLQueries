--drop table #JackData

--select * from FedDataForRecon_View

select type, sum(NetAmount1)  as TotalAlison from FedDataForRecon_View
group by type

SELECT CAMS_RptBillingLedgerBYOR_View.TextTerm, CAMS_RptBillingLedgerBYOR_View.TransDoc, CAMS_RptBillingLedgerBYOR_View.TransType, 
               CAMS_RptBillingLedgerBYOR_View.ShowAmount, CAMS_RptBillingLedgerBYOR_View.RefNo, CAMS_RptBillingLedgerBYOR_View.LastName, 
               CAMS_RptBillingLedgerBYOR_View.FirstName, CAMS_RptBillingLedgerBYOR_View.MiddleName, CAMS_RptBillingLedgerBYOR_View.StudentUID, 
               CAMS_RptBillingLedgerBYOR_View.Term, CAMS_RptBillingLedgerBYOR_View.StudentID, CAMS_RptBillingLedgerBYOR_View.TransDate, 
               tmpRptBillingBYOR.BillingBatchID, tmpRptBillingBYOR.ReportKey, dbo.Student.StudentUID AS Expr1,
               CAST(replace( dbo.Student.StudentSSN,'-','') as varchar) as studentssn
into #JackData
FROM  dbo.tmpRptBillingBYOR AS tmpRptBillingBYOR INNER JOIN
               dbo.CAMS_RptBillingLedgerBYOR_View AS CAMS_RptBillingLedgerBYOR_View ON 
               tmpRptBillingBYOR.ReportKey = CAMS_RptBillingLedgerBYOR_View.ReportKey AND 
               tmpRptBillingBYOR.OwnerUID = CAMS_RptBillingLedgerBYOR_View.StudentUID AND 
               tmpRptBillingBYOR.BillingID = CAMS_RptBillingLedgerBYOR_View.BillingID AND 
               tmpRptBillingBYOR.BillingBatchID = CAMS_RptBillingLedgerBYOR_View.BillingBatchID LEFT OUTER JOIN
               dbo.Student ON tmpRptBillingBYOR.OwnerUID = dbo.Student.StudentUID
WHERE (tmpRptBillingBYOR.ReportKey =360929)

--select * from #JackData

select 
case 
when TransDoc='DLPlus2' then 'DLPlus'
when TransDoc='DLStafford2' then 'DLStafford'
when TransDoc='DLUnsub2' then 'DLUnsub'
else TransDoc
end as TransDoc1
, Sum(showAmount) as TotalJAck 
into #JackData1
from #JackData
group By Transdoc

select 
TransDoc1
, Sum(TotalJAck) as TotalJack
from #JackData1
group By Transdoc1

drop table #JackData1
drop table #JackData