SELECT DISTINCT 
               TOP (100) PERCENT 
			   --TC1.TextTerm AS Term, ST1.StudentUID, ST1.StudentID, 
			   --LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) 
      --         AS FirstName, ST1.MiddleInitial, MM1.MajorMinorName AS DegreeProgram, LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) 
      --         AS USERID
				LTRIM(RTRIM(ST1.LastName)) AS LastName, 
				LTRIM(RTRIM(ST1.FirstName)) AS FirstName,
				St1.Email1 as Email,
				'' as AlternateEmail,
				ST1.StudentID,
				ST1.Address1 ,
				St1.Address2,
				ST1.City as City,
				St1.State as StateCode,
				ST1.ZipCode as Zip,
				ST1.Country as CountryCode,
				'' as Province,
				ST1.Phone1,
				'' as Mobile,
				MM1.MajorMinorName as Major,
				'' as Minor,
				dbo.getStudentGraduationDate(ST1.StudentUID, MM1.MajorMinorID) as GradDate,
				'MAIN' as Campus,
				''  as Major2,
				dbo.getStudentTrocGPA(ST1.StudentUID) as GPA,
				'' as SchoolOf,
				'' as ClassLevel,
				dbo.getStudentGradDegreeName(ST1.StudentUID, MM1.MajorMinorID) as Degree,
				'' as Veteran
				--,st1.studentuid, mm1.MajorMinorID

FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.CAMS_StudentAddressList_View AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.Term >= 'B17Q') 
--AND (NOT (GL1.DisplayText = 'Transfer')) 
AND (NOT (ST1.LastName = 'Testperson'))
AND ST1.AddressType='Local'
AND ST1.ActiveFlag='YEs'

ORDER BY LastName, FirstName

--dbo.getStudentGraduationDate(ST1,StudentUID, MM1.MajorMinorID) as GradDate,
--		select dbo.getstudenttrocgpa(78130)		

--select cast (CumGPA as numeric(6,2)) from CTM_Student_Academic_CumGPA_View
--	WHERe StudentUID='78130'