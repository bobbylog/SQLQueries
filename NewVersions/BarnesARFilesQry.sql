select 
StudentID,
LastName,
FirstName,
StudentMI,
Amount,
'BNCB' as ProviderCode,
'01/01/1990' as BeginDate,
'01/01/1990' as EndDate,
'S' as IDType,
'A' as RecordType,
'D' as AccountType
from CAMS_StudentLedger_View
WHERE TransDoc LIKE 'BK%'

select * from CAMS_StudentLedger_View
WHERE TransDoc like 'BK%'