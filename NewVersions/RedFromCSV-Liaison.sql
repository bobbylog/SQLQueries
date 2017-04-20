Use CAMS_enterprise

Insert into CAMS_Liaison_Inquiries
select *, GETDATE() as DateCollected
from openrowset('MSDASQL'
 ,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}; 
 DefaultDir=D:\SFTP\Liaison\Exports\' 
 ,'select * from "New_Inquiries_to_Export.csv"') T