SELECT DISTINCT 
               '1' AS Code, CAMS_RptRoster_View.TextTerm, CAMS_RptSROfferType1000_View.Department, CAMS_RptSROfferType1000_View.Course, 
               CAMS_RptRoster_View.Section, CAMS_RptSROfferType1000_View.FacultyLastName + ', ' + CAMS_RptSROfferType1000_View.FacultyFirstName AS FacultyName, 
               CAMS_RptSROfferType1000_View.MaximumEnroll, CAMS_RptSROfferType1000_View.CurrentEnroll, '' AS Blank1, '' AS Blank2, '' AS Blank3, '' AS Blank4, 
               '' AS Blank5, CAMS_RptRoster_View.CourseName
FROM  dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               CAMS_RptRoster_View.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               CAMS_RptRoster_View.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               CAMS_RptRoster_View.StudentID = CAMS_RptStudentAddressList_View.StudentID
WHERE (CAMS_RptSROfferType1000_View.SemesterID = 612) AND (CAMS_RptRoster_View.TextTerm = 'FA-16')