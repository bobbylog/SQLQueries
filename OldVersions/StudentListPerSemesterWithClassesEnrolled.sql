SELECT DISTINCT 
               CAMS_RptRoster_View.TextTerm, CAMS_RptSROfferType1000_View.SemesterID, CAMS_RptStudentAddressList_View.LastName, 
               CAMS_RptStudentAddressList_View.FirstName, CAMS_RptStudentAddressList_View.StudentID, CAMS_RptSROfferType1000_View.Department, 
               CAMS_RptSROfferType1000_View.Section, CAMS_RptSROfferType1000_View.Course,CAMS_RptSROfferType1000_View.CourseName
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster LEFT OUTER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID
WHERE (CAMS_RptSROfferType1000_View.SemesterID = 612) AND (CAMS_RptRoster_View.TextTerm = 'FA-16')
