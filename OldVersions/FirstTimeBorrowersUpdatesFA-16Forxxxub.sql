 

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TC.TextTerm AS Term, GL1.DisplayText, TD.TransDoc, 
       ST.StudentID, ST.StudentUID, ST.LastName, ST.FirstName, FAA.FinancialAwardID,
       FAA.TransStatusID
INTO #HOLD1       
FROM CAMS_Enterprise.dbo.FinancialAward FAA
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
      ON (ST.StudentUID = FAA.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = FAA.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Transdoc TD
      ON (TD.TransDocID = FAA.TransTypeID)      
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
      ON (GL1.UniqueId = FAA.TransStatusID)      
WHERE TC.TextTerm IN ('SP-17') AND GL1.DisplayText = 'FIRST TIME BORROWER' /* 2437 */
       AND TD.TransDoc IN ('DLSTAFFORD', 'DLUNSUB', 'DLPLUS'
       , 'DLSTAFFORD2', 'DLUNSUB2', 'DLPLUS2')
     --  AND TD.TransDoc IN ('DLSTAFFORD2', 'DLUNSUB2', 'DLPLUS2')
      
SELECT *
FROM #HOLD1
ORDER BY LastName, FirstName


UPDATE CAMS_Enterprise.dbo.FinancialAward
SET TransStatusID = 2430 /* Approved */
WHERE FinancialAwardID IN (SELECT FinancialAwardID FROM #HOLD1)



SELECT DISTINCT StudentID, LastName, FirstName
FROM #HOLD1
ORDER BY LastName, FirstName

DROP TABLE #HOLD1      