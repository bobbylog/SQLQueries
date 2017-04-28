SELECT TextTerm, StudentID, StudentName, AwardType, Description, 
       CONVERT(decimal(10,2), Amount) AS Amount,
       CONVERT(decimal(10,2), EstimatedAmount) AS EstimatedAmount,
       CONVERT(decimal(10,2), OriginalAmount) AS OriginalAmount,
       case 
          when StudentAccepted = 1 then 'Yes'
          else 'No'
       end AS Accepted, 
       CONVERT(varchar,StudentAcceptedTime, 101) AS StudentAcceptedTime
FROM CAMS_Enterprise.dbo.CAMS_FinancialAward_View  
WHERE
 CONVERT(Date,StudentAcceptedTime) 
 between 
 DATEADD(day, -1, CONVERT(DATE, '04/13/2017'))
 AND DATEADD(day, -1, CONVERT(DATE, '04/27/2017'))
ORDER BY StudentAcceptedTime, StudentName, StudentID, Term asc