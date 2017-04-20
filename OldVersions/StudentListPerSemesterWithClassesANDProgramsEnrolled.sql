SELECT DISTINCT 
               CAMS_RptRoster_View.TextTerm, dbo.CAMS_Student_View.StudentUID, dbo.CAMS_Student_View.LastName, dbo.CAMS_Student_View.FirstName, 
               CAMS_RptSROfferType1000_View.SemesterID, dbo.CAMS_Student_View.Programs
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID INNER JOIN
               dbo.CAMS_Student_View ON tmpRptBYORRoster.StudentUID = dbo.CAMS_Student_View.StudentUID
WHERE (CAMS_RptSROfferType1000_View.SemesterID = 612) AND (CAMS_RptRoster_View.TextTerm = 'FA-16') AND 
               (dbo.CAMS_Student_View.Programs LIKE '%practical%')