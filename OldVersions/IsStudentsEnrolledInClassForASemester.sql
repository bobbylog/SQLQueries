SELECT DISTINCT 
               TOP (100) PERCENT CAMS_RptSROfferType1000_View.SemesterID AS TermCalendarID, CAMS_RptSROfferType1000_View.TextTerm AS Term, 
               CAMS_RptSROfferType1000_View.Department, CAMS_RptSROfferType1000_View.Course, CAMS_RptSROfferType1000_View.CourseName, 
               CAMS_RptSROfferType1000_View.Section, CAMS_RptStudentAddressList_View.StudentUID, CAMS_RptStudentAddressList_View.StudentID, 
               CAMS_RptStudentAddressList_View.LastName, CAMS_RptStudentAddressList_View.FirstName, dbo.Student.StudentSSN, dbo.Student.BirthDate, 
               CAMS_RptStudentAddressList_View.Email1
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster LEFT OUTER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
               dbo.Student ON tmpRptBYORRoster.StudentUID = dbo.Student.StudentUID
WHERE (CAMS_RptSROfferType1000_View.TextTerm IN ('SP-16','SU-16','FA-16')) 
AND CAMS_RptStudentAddressList_View.LastName like 'Szabad'
ORDER BY CAMS_RptSROfferType1000_View.CourseName