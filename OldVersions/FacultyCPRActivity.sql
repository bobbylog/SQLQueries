SELECT derivedtbl_1.FacultyID, derivedtbl_1.Activity, derivedtbl_1.MCompletionDate, dbo.CAMS_Faculty_View.LastName, dbo.CAMS_Faculty_View.FirstName, 
               dbo.CAMS_Faculty_View.Department, dbo.CAMS_Faculty_View.FacultyTitle, dbo.CAMS_Faculty_View.FacultyType, dbo.CAMS_Faculty_View.HireStatus
FROM  OPENROWSET('SQLOLEDB', 'Server=trocaire-sql01;Trusted_Connection=yes;', ' Exec  CAMS_ENterprise.dbo.TCC_Faculty_Activity_CPR') 
               AS derivedtbl_1 INNER JOIN
               dbo.CAMS_Faculty_View ON derivedtbl_1.FacultyID = dbo.CAMS_Faculty_View.FacultyID
 WHERE derivedtbl_1.MCompletionDate is not null