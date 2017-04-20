SELECT TC1.TextTerm AS Term, ST1.LastName + ', ' + St1.FirstName AS FName, 
       SR1.Department + ' - ' + SR1.CourseID + ' - ' + SR1.Section + ' - ' + SR1.CourseType AS Course,
       GL1.DisplayText AS Att,
       CONVERT(varchar,SA1.SADate, 101) AS SADateT, SA1.InsertUserID,
       CONVERT(varchar, SA1.InsertTime, 101) AS InsertDateT,
       SA1.UpdateUserID,
       case
           when SA1.UpdateTime IS NULL then CONVERT(varchar, SA1.InsertTime, 101)
           else CONVERT(varchar, SA1.UpdateTime, 101)
       end AS UpdateTimeT,
       CONVERT(varchar, SA1.UpdateTime, 101) AS UPD,
       DATEDIFF(day, SA1.SADate, SA1.InsertTime) AS InsertDIFF,
       case
           when SA1.UpdateTime IS NULL then 0
           else DATEDIFF(day, SA1.InsertTime, SA1.UpdateTime)
       end AS UpdateDIFF,
       SR1.Coursename
INTO #rawdata
FROM CAMS_Enterprise.dbo.StudentAttendance SA1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
      ON (TC1.TermCalendarID = SA1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
      ON (GL1.UniqueID = SA1.StatusID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.SROffer SR1
      ON (SR1.SROfferID = SA1.SROfferID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
      ON (ST1.StudentUID = SA1.StudentUID)
WHERE TC1.TextTerm = 'Fa-16'  
--      AND ST1.StudentID = @UStudID
ORDER BY SA1.SROfferID, SA1.SADate

SELECT Term, Coursename, SADateT AS AttDate, FName, Course, Att AS Attendance
FROM #rawdata 
/*WHERE NOT (InsertDIFF < 4 AND UpdateDiff < 4)*/
ORDER BY FName, Coursename,SADateT

DROP TABLE #rawdata

