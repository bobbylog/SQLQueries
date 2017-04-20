
	SELECT 'Accepted' as Status, dbo.getTermText(S.ExpectedTermID) as Term, S.AdmitDate as DateAdmitted, 	S.DateAccepted as DateApplied,  S.ProspectStatus As ApplicantStatus, dbo.getMajorName(S.ProgramsID) as Major,  
	       S.StudentID, S.StudentUID, S.LastName, S.FirstName, s.MiddleName as MiddleInitial, S.birthdate, dbo.getStudentEmailAddress(S.StudentUID) as Email,
	       dbo.getStudentPhoneNo(S.StudentUID) as Phone, 
	       SH.Measles, SH.Measles2, SH.Mumps, SH.Rubella,SH.ExaminedDate as PhysicalDate, SH.TBTestDate1 as PPD1, SH.TBTestDate2 as PPD2, 
	       SH.HepatitisB1,SH.HepatitisB2, SH.HepatitisB3,SH.Meningitis, SH.MeningitisType , '' as CPR, '' as FluShot, '' as HIPPATRNG , SH.Explanations 
	--,sh.*
	into #AcceptList
	from CAMS_Student_View S
	left outer  join CAMS_StudentHealth_view  SH
	on s.StudentUID=sh.StudentUID
	where 
	(S.ProspectStatus='APPLICANT' OR S.ProspectStatus='ACCEPTED')
	AND S.ExpectedTermID=dbo.getTermID('FA-17')
	and S.ProgramsID=109
	order by S.AdmitDate asc
	
	
SELECT  TC1.TextTerm AS Term,
        ST1.StudentUID, ST1.StudentID,  dbo.getStudentEmailAddress(ST1.StudentUID) as Email,
	       dbo.getStudentPhoneNo(ST1.StudentUID) as Phone, 
	    ST1.DateAccepted as DateApplied, ST1.AdmitDate as DateAdmitted, dbo.getProspectStatus(ST1.ProspectStatusID) as ProspectStat, 
        ST1.LastName, ST1.FirstName, ST1.MiddleInitial, ST1.BirthDate, MM1.MajorMinorName,
        SUM(SR1.Credits) AS SCRED, SR1.RegistrationStatus AS Official, GL1.DisplayText AS Category,
        ES1.Status AS RegStatus, MM1.MajorMinorName AS Program, TC1.TextTerm
INTO #Snapshot
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
LEFT OUTER JOIN CAMS_Enterprise.dbo.EnrollmentStatus ES1 
       ON (SS1. EnrollmentStatusID = ES1. EnrollmentStatusID)
WHERE TC1.TextTerm = 'FA-17' AND (GL1.DisplayText = 'Curriculum') AND NOT MM1.MajorMinorName = 'Non-Matriculant'   
      AND NOT (ST1.LastName = 'Testperson') AND NOT SR1.Grade = 'AU' AND NOT SR1.Grade = 'W' 
GROUP BY TC1.TextTerm, ST1.StudentUID, ST1.StudentID, 
               ST1.LastName, ST1.FirstName, ST1.MiddleInitial, ST1.BirthDate,
               ST1.DateAccepted , ST1.AdmitDate, ST1.ProspectStatusID,
               SR1.RegistrationStatus, GL1.DisplayText, ES1.Status, MM1.MajorMinorName
               
               
ORDER BY ST1.LastName, ST1.StudentID

SELECT DISTINCT S.StudentID, S.StudentUID, S.LastName, S.FirstName, 
                S.MiddleInitial, S.RegStatus, S.SCRED, S.MAJORMinorName,
                S.DateAdmitted,S.DateApplied,S.Email,S.Phone,S.TextTerm, S.ProspectStat,
                SH.ExaminedDate as PhysicalDate, SH.TBTestDate1 as PPD1, SH.TBTestDate2 as PPD2, 
	            SH.HepatitisB1,SH.HepatitisB2, SH.HepatitisB3,SH.Meningitis, SH.MeningitisType , '' as CPR, '' as FluShot, '' as HIPPATRNG ,
                case
                    when S.BirthDate IS NULL THEN ''
                    else CONVERT(varchar, S.BirthDate, 101)
                end AS BirthDate,
               
                case
                    when S.SCRED > 11 then 'FT'
                    else 'PT'
                end AS FTPT,
                
                case
                    when SH.Measles IS NULL THEN ''
                    else CONVERT(varchar, SH.Measles, 101)
                end AS Measles,
                case
                    when SH.Measles2 IS NULL THEN ''
                    else CONVERT(varchar, SH.Measles2, 101)
                end AS Measles2,
                case
                    when SH.Mumps IS NULL THEN ''
                    else CONVERT(varchar, SH.Mumps, 101)
                end AS Mumps,
                case
                    when SH.Rubella IS NULL THEN ''
                    else CONVERT(varchar, SH.Rubella, 101)
                end AS Rubella, SH.Explanations
INTO #A1957  
FROM #Snapshot S
LEFT OUTER JOIN CAMS_Enterprise.dbo.CAMS_StudentHealth_view SH
      ON (S.StudentUID = SH.StudentUID)
WHERE S.BirthDate > '1/1/1957' OR S.BirthDate IS NULL
ORDER BY S.RegStatus, S.LastName, S.FirstName

SELECT A.TextTerm as Term,A.DateAdmitted,A.DateApplied,A.ProspectStat as ApplicantStatus,A.MajorMinorName as Major,A.StudentID, A.StudentUID, A.LastName, A.FirstName, A.MiddleInitial, 
       A.BirthDate,A.Email,CSV1.Phone1 AS Phone,  
       A.Measles, A.Measles2, A.Mumps, A.Rubella,
       A.PhysicalDate, A.PPD1, A.PPD2, 
	   A.HepatitisB1,A.HepatitisB2, A.HepatitisB3,A.Meningitis, A.MeningitisType , A.CPR,A.FluShot, A.HIPPATRNG ,
        '  ' + A.Explanations AS Explanations
      
INTO #Check
FROM #A1957 A
LEFT OUTER JOIN CAMS_Enterprise.dbo.CAMS_StudentAddressList_View CSV1
       ON (A.StudentUID = CSV1.StudentUID)
WHERE /*NOT A.RegStatus = 'Continuing' AND*/ CSV1.AddressType = 'Local' AND CSV1.ActiveFlag = 'Yes'
      AND A.SCRED > 5
ORDER BY A.LastName, A.FirstName, A.MiddleInitial

SELECT * FROM #AcceptList
union all
SELECT 'Admitted' as Status, *
FROM #Check
WHERE Measles = '' OR Measles2 = '' OR Mumps = '' OR Rubella = ''
--Order by LastName

DROP TABLE #AcceptList
DROP TABLE #Snapshot
DROP TABLE #A1957
DROP TABLE #Check