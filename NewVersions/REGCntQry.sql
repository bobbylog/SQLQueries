DECLARE @UTerm varchar(25)



set @UTerm='fa-16'
    -- Insert statements for procedure here
SELECT ST1.StudentUID, ST1.StudentID
INTO #NewStudents
FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
WHERE TC1.TextTerm = @UTerm AND
      GL1.DisplayText = 'Curriculum' AND
      NOT ST1.LastName = 'Testperson' AND
      ((SR1.Department IN ('OR', 'OS', 'OT')) OR ((SR1.Department = 'BSN') AND (SR1.CourseID = '100'))) 
ORDER BY ST1.StudentUID


SELECT ST1.StudentUID, ST1.StudentID, ST1.LastName, TC1.TextTerm, MM1.MajorMinorName, SP1.SequenceNo, 
       GL3.DisplayText AS STUSD, ISNULL(GL4.DisplayText, ' ') AS Tracking, SUM(SR1.Credits) AS SCRED
INTO #GetStudents
FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentStatus SS1
       ON ((SR1.StudentUID = SS1.StudentUID) AND 
           (SR1.TermCalendarID = SS1.TermCalendarID))
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentProgram SP1
       ON (SS1.StudentStatusID = SP1.StudentStatusID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.MajorMinor MM1
       ON (SP1.MajorProgramID = MM1.MajorMinorID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL3
       ON (ST1.UserDefinedFieldID = GL3.UniqueID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentStatusUDef SSU1
       ON (SS1.StudentStatusID = SSU1.StudentStatusID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL4
       ON (SSU1.UDefLookup1 = GL4.UniqueID)        
WHERE TC1.TextTerm = @UTerm AND
      GL1.DisplayText = 'Curriculum' AND
      NOT ST1.LastName = 'Testperson' AND NOT SR1.Grade = 'W' 
GROUP BY ST1.STUDENTUID, ST1.StudentID, ST1.LastName, TC1.TextTerm, MM1.MajorMinorName, SP1.SequenceNo, GL3.DisplayText, GL4.DisplayText
ORDER BY MM1.MajorMinorName, ST1.StudentID

SELECT GS14.StudentUID, GS14.StudentID, GS14.LastName, GS14.TextTerm, GS14.MajorMinorName, GS14.SequenceNo, 
       GS14.STUSD, GS14.Tracking, GS14.SCRED,
       case
           when exists (SELECT NS.* FROM #NewStudents NS WHERE NS.StudentUID = GS14.StudentUID) then 'Yes'
           else 'No'
       end AS NewS 
INTO #PStudents          
FROM #GetStudents GS14       

SELECT DISTINCT PS.TextTerm, PS.MajorMinorName,
       (SELECT COUNT(PS2.StudentID) 
        FROM #PStudents PS2 
        WHERE PS2.MajorMinorName = PS.MajorMinorName AND PS2.SCRED > 11 AND PS2.SequenceNo = 0) AS FT0CNT, 
       (SELECT COUNT(PS3.StudentID) 
        FROM #PStudents PS3 
        WHERE PS3.MajorMinorName = PS.MajorMinorName AND PS3.SCRED < 12 AND PS3.SequenceNo = 0) AS PT0CNT,
       (SELECT COUNT(PS4.StudentID) 
        FROM #PStudents PS4 
        WHERE PS4.MajorMinorName = PS.MajorMinorName AND PS4.SCRED > 11 AND PS4.SequenceNo = 1) AS FT1CNT, 
       (SELECT COUNT(PS5.StudentID) 
        FROM #PStudents PS5 
        WHERE PS5.MajorMinorName = PS.MajorMinorName AND PS5.SCRED < 12 AND PS5.SequenceNo = 1) AS PT1CNT,
       (SELECT COUNT(PS6.StudentID) 
        FROM #PStudents PS6 
        WHERE PS6.MajorMinorName = PS.MajorMinorName AND PS6.SCRED < 12 AND PS6.STUSD = 'P-Tech' AND NOT PS6.Tracking = 'Lancaster HS'
        ) AS PTHSCNT,
       (SELECT COUNT(PS7.StudentID) 
        FROM #PStudents PS7 
        WHERE PS7.MajorMinorName = PS.MajorMinorName AND PS7.SCRED > 11 AND PS7.STUSD = 'P-tech' AND NOT PS7.Tracking = 'Lancaster HS'
        ) AS FTHSCNT, 
       (SELECT COUNT(PS8.StudentID) 
        FROM #PStudents PS8 
        WHERE PS8.MajorMinorName = PS.MajorMinorName AND PS8.SCRED < 12 AND PS8.STUSD = 'YEA' AND PS8.Tracking = 'Lancaster HS'
       ) AS PTHSLCNT,
       (SELECT COUNT(PS9.StudentID) 
        FROM #PStudents PS9 
        WHERE PS9.MajorMinorName = PS.MajorMinorName AND PS9.SCRED > 11 AND PS9.STUSD = 'YEA' AND PS9.Tracking = 'Lancaster HS'
        ) AS FTHSLCNT, 
       (SELECT COUNT(PS10.StudentID) 
        FROM #PStudents PS10 
        WHERE PS10.MajorMinorName = PS.MajorMinorName AND PS10.SequenceNo = 0 AND PS10.NewS = 'Yes') AS New0CNT,
       (SELECT COUNT(PS11.StudentID) 
        FROM #PStudents PS11 
        
        WHERE PS11.MajorMinorName = PS.MajorMinorName AND PS11.SequenceNo = 1 AND PS11.NewS = 'Yes') AS New1CNT                
INTO #Raw2                                         
FROM #PStudents PS

select distinct stusd, Tracking  from #PStudents


SELECT R2.TextTerm, R2.MajorMinorName, 
                          R2.FT0CNT AS FT, 
                          R2.PT0CNT AS PT, 
                          R2.FT0CNT + R2.PT0CNT AS Total, 
                          R2.FT1CNT AS FT_DM, 
                          R2.PT1CNT AS PT_DM, 
                          R2.PTHSCNT AS PT_HS, 
                          R2.FTHSCNT AS FT_HS,
                          R2.PTHSLCNT AS PT_HSL, 
                          R2.FTHSLCNT AS FT_HSL,
                          R2.New0CNT AS New,
                          R2.New1CNT AS New_DM                          
FROM #Raw2 R2
ORDER BY R2.MajorMinorName

DROP TABLE #NewStudents
DROP TABLE #GetStudents
DROP TABLE #PStudents
DROP TABLE #Raw2