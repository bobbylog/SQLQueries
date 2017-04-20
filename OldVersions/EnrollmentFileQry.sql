SELECT distinct '1' AS Code, 
       CAMS_RptRoster_View.TextTerm, 
       CAMS_RptSROfferType1000_View.Department, 
       CAMS_RptSROfferType1000_View.Course, 
       CAMS_RptRoster_View.Section,
      CAMS_RptSROfferType1000_View.FacultyLastName+', '+CAMS_RptSROfferType1000_View.FacultyFirstName as FacultyName,
                CAMS_RptSROfferType1000_View.MaximumEnroll, 
                CAMS_RptSROfferType1000_View.CurrentEnroll, '' as Blank1, '' as Blank2, '' as Blank3, '' as Blank4, '' as Blank5,
               CAMS_RptRoster_View.CourseName 
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster LEFT OUTER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID
WHERE (CAMS_RptSROfferType1000_View.SemesterID = 612) AND (CAMS_RptRoster_View.TextTerm = 'FA-16')

