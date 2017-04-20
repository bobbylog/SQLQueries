SELECT DISTINCT 
               '1' AS Code, TextTerm, Department, Course, Section, FacultyLastName + ', ' + FacultyFirstName AS FacultyName, MaximumEnroll, CurrentEnroll, '' AS Blank1, 
               '' AS Blank2, '' AS Blank3, '' AS Blank4, '' AS Blank5, CourseName
FROM  dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View
WHERE (TextTerm = 'SP-17')