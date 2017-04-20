select distinct T1.* from 
(SELECT dbo.CAMS_Student_View.StudentUID, dbo.CAMS_Student_View.Type, dbo.CAMS_Student_View.Salutation, dbo.CAMS_Student_View.LastName, 
               dbo.CAMS_Student_View.FirstName, dbo.CAMS_Student_View.MiddleName, dbo.CAMS_Student_View.MaidenName, dbo.CAMS_Student_View.EnrollmentStatus, 
               dbo.CAMS_Student_View.BirthDate, dbo.CAMS_Student_View.Programs, dbo.CAMS_Student_View.DateAccepted, dbo.CAMS_Student_View.UserDefined, 
               dbo.HighSchools.HighSchoolCode, dbo.CAMS_Student_View.ExpectedTerm, dbo.CAMS_Student_View.ProspectStatus, 
               dbo.CAMS_StudentBYORType1000_View.Address1, dbo.CAMS_StudentBYORType1000_View.Address2, dbo.CAMS_StudentBYORType1000_View.Address3, 
               dbo.CAMS_StudentBYORType1000_View.City, dbo.CAMS_StudentBYORType1000_View.State, dbo.CAMS_StudentBYORType1000_View.ZipCode, 
               dbo.CAMS_StudentBYORType1000_View.Country, dbo.CAMS_StudentBYORType1000_View.Phone1, dbo.CAMS_StudentBYORType1000_View.Phone2, 
               dbo.CAMS_StudentBYORType1000_View.Email1, dbo.CAMS_StudentBYORType1000_View.Email2, dbo.CAMS_StudentBYORType1000_View.InternationalFlag, 
               dbo.StudentHighSchool.ACTCOMPOSITE, dbo.StudentHighSchool.SATVERBAL, dbo.StudentHighSchool.SATMATH, dbo.StudentHighSchool.SATCOMP, 
               dbo.StudentHighSchool.HSGPA1, dbo.StudentHighSchool.HSGPA2, dbo.TermCalendar.TextTerm, dbo.TermCalendar.TermCalendarID
FROM  dbo.CAMS_StudentBYORType1000_View INNER JOIN
               dbo.TermCalendar ON dbo.CAMS_StudentBYORType1000_View.ExpectedTerm = dbo.TermCalendar.TextTerm RIGHT OUTER JOIN
               dbo.CAMS_Student_View INNER JOIN
               dbo.Student_Address ON dbo.CAMS_Student_View.StudentUID = dbo.Student_Address.StudentID INNER JOIN
               dbo.Address ON dbo.Student_Address.AddressID = dbo.Address.AddressID ON 
               dbo.CAMS_StudentBYORType1000_View.StudentUID = dbo.CAMS_Student_View.StudentUID LEFT OUTER JOIN
               dbo.StudentHighSchool ON dbo.CAMS_Student_View.StudentUID = dbo.StudentHighSchool.StudentUID LEFT OUTER JOIN
               dbo.HighSchools ON dbo.StudentHighSchool.HighSchoolID = dbo.HighSchools.HighSchoolID LEFT OUTER JOIN
               dbo.Greeting ON dbo.CAMS_Student_View.StudentUID = dbo.Greeting.OwnerUID
WHERE (dbo.CAMS_StudentBYORType1000_View.ActiveFlag = 'yes'))T1
WHERE T1.TermCalendarID >=612
