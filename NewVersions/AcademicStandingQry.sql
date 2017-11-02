
    -- Insert statements for procedure here
    
SELECT  FA2.LastName, FA2.FirstName, ADD2.Email1
INTO #ADI
FROM CAMS_Enterprise.dbo.Faculty FA2
LEFT OUTER JOIN CAMS_Enterprise.dbo.Faculty_Address FAA2
       ON (FAA2.FacultyID = FA2.FacultyID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADD2
       ON (FAA2.AddressID = ADD2.AddressID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL8
       ON (ADD2.AddressTypeID = GL8.UniqueId)
WHERE FA2.Active = 1 AND ADD2.ActiveFlag = 'Yes' AND GL8.DisplayText = 'Local'
ORDER BY FA2.LastName, FA2.FirstName  
    
SELECT /*TOP 20*/ ST1.StudentID, ST1.StudentUID, TC1.TextTerm,
       ST1.LastName, ST1.FirstName, 
       case
            when NOT (ADV1.FormalName IS NULL) then ADV1.FormalName
            else ''
       end AS AdvisorName,
       case
           when EXISTS (SELECT ADR1.Email1
                 FROM CAMS_Enterprise.dbo.Student_Address STA1
                 LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
                       ON (STA1.AddressID = ADR1.AddressID)
                 LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL8
                       ON (ADR1.AddressTypeID = GL8.UniqueId)
                 WHERE GL8.DisplayText = 'local' AND ADR1.ActiveFlag = 'Yes' AND STA1.StudentID = SR1.StudentUID) then 
                 (SELECT TOP 1 ADR1.Email1
                 FROM CAMS_Enterprise.dbo.Student_Address STA1
                 LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
                       ON (STA1.AddressID = ADR1.AddressID)
                 LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL8
                       ON (ADR1.AddressTypeID = GL8.UniqueId)
                 WHERE GL8.DisplayText = 'local' AND ADR1.ActiveFlag = 'Yes' AND STA1.StudentID = SR1.StudentUID) /*'duewigerp@trocaire.edu'*/
                 else ''
       end AS Email,            
       SR1.Department + SR1.CourseID + ' ' + SR1.Section AS CourseNum,
       SR1. CourseName, SR1.MidTermGrade,
       case
           when EXISTS (SELECT A.Email1 
                        FROM #ADI A
                        WHERE A.LastName = ADV1.LastName AND A.FirstName = ADV1.FirstName) then
                       (SELECT A.Email1 
                        FROM #ADI A
                        WHERE A.LastName = ADV1.LastName AND A.FirstName = ADV1.FirstName)  /*'duewigerp@trocaire.edu'*/
           else ''
       end AS AdvEmail                    

FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student_Address STA1
       ON (SR1.StudentUID = STA1.StudentID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
       ON (STA1.AddressID = ADR1.AddressID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL2
       ON (ADR1.AddressTypeID = GL2.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL3
       ON (ADR1.StateID = GL3.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentStatus SS1
       ON ((SR1.StudentUID = SS1.StudentUID) AND 
           (SR1.TermCalendarID = SS1.TermCalendarID))
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentProgram SP1
       ON (SS1.StudentStatusID = SP1.StudentStatusID AND SP1.SequenceNo = 0)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Advisors ADV1
       ON (SP1.AdvisorID = ADV1.AdvisorID)
WHERE TC1.TextTerm = 'FA-17' AND
      SR1.RegistrationStatus = 'Official' AND
      GL1.DisplayText = 'Curriculum' AND
      SR1.MidTermGrade IN ('C-', 'D+', 'D', 'F', 'FX', 'U') AND
      NOT SR1.Grade = 'W' AND
      GL2.DisplayText = 'Local' AND
      ADR1.ActiveFlag = 'Yes' /*AND
      ADV1.FormalName = 'Nesbitt, Kristin'*/
--ORDER BY CASE WHEN @USort = 'student' THEN ST1.LastName + ST1.FirstName + ST1.StudentID
--              WHEN @USort = 'advisor' THEN ADV1.FormalName + ST1.LastName + ST1.FirstName + ST1.StudentID
--              WHEN @USort = 'course'  THEN SR1.Department + SR1.CourseID + SR1.Section + ST1.LastName + ST1.FirstName 
--              ELSE  ST1.LastName + ST1.FirstName + ST1.StudentID
--         END
         
 DROP TABLE #ADI        


