SELECT DISTINCT 
               
               CAMS_RptRoster_View.TextTerm,CAMS_RptStudentAddressList_View.LastName, CAMS_RptStudentAddressList_View.FirstName , CAMS_RptStudentAddressList_View.Email1
              
FROM  dbo.tmpRptBYORRoster AS tmpRptBYORRoster LEFT OUTER JOIN
               dbo.CAMS_RptStudentAddressList_View AS CAMS_RptStudentAddressList_View ON 
               tmpRptBYORRoster.StudentUID = CAMS_RptStudentAddressList_View.StudentUID AND 
               tmpRptBYORRoster.AddressTypeID = CAMS_RptStudentAddressList_View.AddressTypeID INNER JOIN
               dbo.CAMS_RptRoster_View AS CAMS_RptRoster_View ON tmpRptBYORRoster.StudentUID = CAMS_RptRoster_View.StudentUID AND 
               tmpRptBYORRoster.SRAcademicID = CAMS_RptRoster_View.SRAcademicID INNER JOIN
               dbo.CAMS_RptSROfferType1000_View AS CAMS_RptSROfferType1000_View ON 
               tmpRptBYORRoster.SROfferID = CAMS_RptSROfferType1000_View.SROfferID
WHERE (CAMS_RptRoster_View.TextTerm = 'FA-16') AND 
               (CAMS_RptStudentAddressList_View.ActiveFlag = 'yes')