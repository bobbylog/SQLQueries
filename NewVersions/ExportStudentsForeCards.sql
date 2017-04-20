Select * 
From CUS_GeneralMetersExport_View 
WHERE (1=1)  
AND (TypeID IN (2633,2634))  
AND (AddressTypeID = 287)  
AND (TermCalendarID = 614)  
AND ExpectedTermSeq Between 'B16Q' AND 'B17C' 
AND ((AdmitDate Between '12/30/1899 12:00:00 am' AND '12/31/9999 11:59:59 pm') OR (AdmitDate is Null)) 