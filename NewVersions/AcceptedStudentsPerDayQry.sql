DECLARE @dt datetime

set @dt=GETDATE()

SELECT DISTINCT dbo.CAMS_Student_View.StudentUID,
               dbo.CAMS_Student_View.StudentID, dbo.CAMS_Student_View.LastName, dbo.CAMS_Student_View.FirstName, dbo.CAMS_StudentAddressList_View.Address1, 
               dbo.CAMS_StudentAddressList_View.AddressType, dbo.CAMS_StudentAddressList_View.City, dbo.CAMS_StudentAddressList_View.State, 
               dbo.CAMS_StudentAddressList_View.ZipCode, dbo.CAMS_StudentProgram_View.MajorDegree, dbo.CAMS_Student_View.ExpectedTerm, 
               dbo.CAMS_Student_View.AdmitDate, dbo.CAMS_StudentAddressList_View.Email1, dbo.CAMS_StudentAddressList_View.ActiveFlag,
               dbo.CAMS_Student_View.ProspectStatus as ApplicantStatus, dbo.CAMS_Student_View.Type, 
               dbo.CAMS_StudentProgram_View.StudentStatus

   into #tmpList            
FROM  dbo.CAMS_Student_View INNER JOIN
               dbo.CAMS_StudentAddressList_View ON dbo.CAMS_Student_View.StudentUID = dbo.CAMS_StudentAddressList_View.StudentUID LEFT OUTER JOIN
               dbo.CAMS_StudentProgram_View ON dbo.CAMS_Student_View.StudentUID = dbo.CAMS_StudentProgram_View.StudentUID LEFT OUTER JOIN
               dbo.StudentPortal ON dbo.CAMS_Student_View.StudentUID = dbo.StudentPortal.StudentUID
               
WHERE (dbo.CAMS_StudentAddressList_View.AddressType = 'Local') AND (dbo.CAMS_Student_View.AdmitDate <> '') AND 
               (dbo.CAMS_Student_View.ProspectStatusID IN (1, 3))
                AND (dbo.CAMS_Student_View.ExpectedTerm = 'fa-17') 
               AND dbo.CAMS_StudentAddressList_View.ActiveFlag='Yes'
               AND dbo.CAMS_StudentProgram_View.TermCalendarID= 616
               AND MONTH (dbo.CAMS_Student_View.AdmitDate )=MONTH(@dt)
              -- AND DAY (dbo.CAMS_Student_View.AdmitDate )=DAY(@dt)-1
               AND YEAR (dbo.CAMS_Student_View.AdmitDate )=YEAR(@dt)
               AND dbo.CAMS_StudentAddressList_View.Email1=''
               

select * from #tmpList   
            
select * from StudentPortal 
where
StudentUID in
(select StudentUID from #tmpList)

drop table #tmpList