SELECT DISTINCT 
               TOP (100) PERCENT CAMS_RptBillingLedgerBYOR_View.TextTerm, CAMS_RptBillingLedgerBYOR_View.TransDoc, 
               CAMS_RptBillingLedgerBYOR_View.TransType, CAMS_RptBillingLedgerBYOR_View.ShowAmount, CAMS_RptBillingLedgerBYOR_View.RefNo, 
               CAMS_RptBillingLedgerBYOR_View.LastName, CAMS_RptBillingLedgerBYOR_View.FirstName, CAMS_RptBillingLedgerBYOR_View.MiddleName, 
               CAMS_RptBillingLedgerBYOR_View.StudentUID, CAMS_RptBillingLedgerBYOR_View.Term, CAMS_RptBillingLedgerBYOR_View.StudentID, 
               CAMS_RptBillingLedgerBYOR_View.TransDate, MONTH(CAMS_RptBillingLedgerBYOR_View.TransDate) AS mtd, dbo.Student.StudentSSN
FROM  dbo.CAMS_RptBillingLedgerBYOR_View AS CAMS_RptBillingLedgerBYOR_View LEFT OUTER JOIN
               dbo.Student ON CAMS_RptBillingLedgerBYOR_View.StudentUID = dbo.Student.StudentUID
WHERE (MONTH(CAMS_RptBillingLedgerBYOR_View.TransDate) BETWEEN 06 AND 09) AND (CAMS_RptBillingLedgerBYOR_View.TextTerm IN ('fa-16', 'su-16', 'sp-16', 
               'sp-17')) AND (CAMS_RptBillingLedgerBYOR_View.TransDoc LIKE 'dl%')
ORDER BY CAMS_RptBillingLedgerBYOR_View.StudentID