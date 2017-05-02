	DECLARE @Uterm varchar(10)
	DECLARE @Uterm1 varchar(10)
	--drop table #TmpReg1
	--drop table #TmpReg
	
	set @Uterm='SU-17'
	set @Uterm1='SU-17'
	--select *  from termcalendar
	--where term between 'B17L' and 'B19L'
	-- order by Term desc
	
	--select
	--A.StudentID, A.StudentUID, A.LastName, A.FirstName, A.MiddleName as MiddleInitial, A.ProspectStatus As ApplicantStatus, A.AdmitDate as DateAdmitted, 
	--A.DateAccepted as DateApplied, A.birthdate, dbo.getStudentEmailAddress(A.StudentUID) as Email,dbo.getStudentPhoneNo(A.StudentUID) as Phone,  A.Expectedtermid, dbo.getTermText(A.ExpectedTermID) as Term,
	--dbo.isstudentenrolled(a.studentuid, a.ExpectedTermID) as Enrolled,
	--dbo.isstudentregisteredFormTerm(a.studentuid, a.ExpectedTermID) as Registered, 
	--Case when B.MajorDegreeID Is null then A.ProgramsID else B.MajorDegreeID end as MajorIdent,
	--Case when B.MajorDegree Is null then A.Programs else B.MajorDegree end as MajorName
	--into #TmpReg
	--from cams_Student_view A
	--left outer join CAMS_StudentProgram_View B
	--on A.StudentUID=B.StudentUID
	--and A.ExpectedTermID=B.TermCalendarID
	--where A.ExpectedTermID between dbo.getTermID(@UTerm) and dbo.getTermID(@UTerm1)
	--and A.ProspectStatus in ('Admitted','Accepted')
	--order by A.LastName

	
	--	select case 
	--		when TA.Enrolled=1 and TA.Registered=1 then 'Accepted and Registered' 
	--		when TA.Enrolled=1 and TA.Registered=0 then 'Accepted and Enrolled' 
	--		else 'Accepted Only' end as TStatus,
	--		 TA.* 
	--		into #TmpReg1
	--		from #TmpReg TA
			
	--	select * from #TmpReg1
	--	where 
	--		ExpectedTermID between dbo.getTermID(@UTerm) and dbo.getTermID(@UTerm1)
	--		AND Enrolled=1 
	--		and Registered=1
	--		and	 Term='su-17'
	--	order by Term, TStatus, DateAdmitted asc
   --MM1.MajorMinorName AS DegreeProgram,
   
   SELECT DISTINCT 
               TOP (100) PERCENT 
               'Registered' as TStatus, St1.EnrollmentStatus, TC1.TextTerm AS Term, ST1.StudentID, ST1.StudentUID, LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) 
               AS FirstName, ST1.MiddleName as MiddleInitial, St1.ProspectStatus as ApplicantStatus, st1.AdmitDate as DateAdmitted, St1.DateAccepted as DateApplied,St1.BirthDate
               ,dbo.getStudentEmailAddress(st1.StudentUID) as Email, dbo.getStudentPhoneNo(St1.StudentUID) as Phone,  st1.Expectedtermid, Tc1.TextTerm as Term1,
	dbo.isstudentenrolled(st1.studentuid, tc1.TermCalendarID) as Enrolled,
	dbo.isstudentregisteredFormTerm(st1.studentuid, tc1.TermCalendarID) as Registered, 
	MM1.MajorMinorID AS MAjorIdent, MM1.MajorMinorName AS MAjorName
FROM  dbo.CAMS_Student_View AS ST1 LEFT OUTER JOIN
               dbo.CAMS_StudentAddressList_View ON ST1.StudentUID = dbo.CAMS_StudentAddressList_View.StudentUID RIGHT OUTER JOIN
               dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId ON ST1.StudentUID = SR1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE TC1.Term = dbo.getTermOrdSeq(dbo.gettermid(@Uterm)) 
AND
st1.StudentUID not in 
(
select distinct sr.studentuid from sracademic sr
inner join TermCalendar tc2
on SR.TermCalendarID=TC2.TermCalendarID
 where tc2.Term <dbo.getTermOrdSeq(615)
)

--AND dbo.getTermOrdSeq(dbo.gettermid(@Uterm1))
 AND (NOT (GL1.DisplayText = 'Transfer')) AND (NOT (ST1.LastName = 'Testperson'))
AND ST1.ProspectStatus in ('ACCEPTED', 'ADMITTED')

ORDER BY TextTerm, LastName, FirstName
   
   
	--drop table #TmpReg1
	--drop table #TmpReg
	