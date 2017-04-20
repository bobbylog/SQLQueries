select TA.* from (
SELECT DISTINCT
	Max(BILL.BillingID) as BillingID
	,BILL.InsertTime
	-- , TRANS.TransDoc
	,'STUDENTACCOUNTS' AS Department
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
AND BILL.TransDate between '08/01/2016' AND '08/30/2016'


GROUP BY 
BILL.BillingID,
BILL.InsertTime,
STDNT.StudentID
, BILL.Debits
	,STDNT.FirstName
	,STDNT.MiddleInitial
	,STDNT.LastName
	,dbo.CAMS_StudentAddressList_View.Address1
	,dbo.CAMS_StudentAddressList_View.City
	,dbo.CAMS_StudentAddressList_View.State
	,dbo.CAMS_StudentAddressList_View.ZipCode
	,dbo.CAMS_StudentAddressList_View.Country
	,dbo.CAMS_StudentAddressList_View.Email1
	,dbo.CAMS_StudentAddressList_View.AddressType
) TA

INNER JOIN  

(
SELECT DISTINCT
    STDNT.StudentID as PripId
	,Max(BILL.BillingID) as BillingID
	
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
AND BILL.TransDate between '08/01/2016' AND '08/30/2016'

GROUP BY 
STDNT.StudentID
) TB

ON TA.BillingID = TB.BillingID