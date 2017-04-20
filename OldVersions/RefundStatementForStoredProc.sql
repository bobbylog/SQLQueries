select TB.Department, TB.RefundAmount, TB.PripId, TB.PripDomain, 
               TB.PripFirst, TB.PripMiddle,TB.PriPLast,TB.AuthPid, TB.AuthPDomain, TB.AuthPFirst, TB.AuthPMiddle, 
               TB.AuthPLast,  TB.AddrLine1, TB.City, TB.State, TB.Zip, TB.Country, TB.email
FROM
(               
SELECT DISTINCT
	 BILL.TransDate
	, TRANS.TransDoc
	,'' AS Department
	, BILL.Debits AS RefundAmount
	, STDNT.StudentID as PripId
	,'Student' AS PripDomain
	,STDNT.FirstName as PripFirst
	,STDNT.MiddleInitial as PripMiddle
	,STDNT.LastName as PripLast
	,'' as AuthPId
	,'TROCAIRE' as AuthpDomain
	,'' as AuthPFirst
	,'' as AuthPMiddle
	,'' as AuthPLast
	,dbo.CAMS_StudentAddressList_View.Address1 AS AddrLine1
	,dbo.CAMS_StudentAddressList_View.City AS City
	,dbo.CAMS_StudentAddressList_View.State AS State
	,dbo.CAMS_StudentAddressList_View.ZipCode AS Zip
	,dbo.CAMS_StudentAddressList_View.Country
	,dbo.CAMS_StudentAddressList_View.Email1 AS email
	,dbo.CAMS_StudentAddressList_View.AddressType
from Billing as BILL
	INNER JOIN Student as STDNT ON STDNT.StudentUID = BILL.OwnerUID
	INNER JOIN TermCalendar	as TERM ON TERM.TermCalendarID = BILL.TermCalendarID
	LEFT OUTER JOIN Contact	as CONT ON BILL.A1098FilerID =  CONT.ContactID
	INNER JOIN TransDoc as TRANS ON BILL.TransDocID = TRANS.TransDocID
	INNER JOIN ExtendedDocumentTypes as EXT ON EXT.ExtendedDocumentTypesID = BILL.ExtTypeID
	INNER JOIN Glossary as G3 ON G3.UniqueID = BILL.ARTypeID
	INNER JOIN Glossary as G4 ON G4.UniqueID = BILL.CreditCardTypeID
	INNER JOIN dbo.CAMS_StudentAddressList_View ON STDNT.StudentUID = dbo.CAMS_StudentAddressList_View.StudentUID

Where (TRANS.ReportFlag = 'Yes') -- AND
-- BILL.TransDate between @stDate AND @enDate
AND TRANS.TransDoc='REFUND'
AND dbo.CAMS_StudentAddressList_View.AddressType='Local'
AND dbo.CAMS_StudentAddressList_View.ActiveFlag='Yes'
) TB
WHERE TransDate between '08/01/2016' AND '08/30/2016'
order by pripid


