 drop table #TmpAccepted1
	drop table #TmpAccepted
	
DECLARE @UTerm varchar(10)
DECLARE @StuMajor varchar(10)

set @UTerm='FA-17'
set @StuMajor='109'

	select
	A.StudentID, A.StudentUID, A.LastName, A.FirstName, A.MiddleName as MiddleInitial, A.ProspectStatus As ApplicantStatus, A.AdmitDate as DateAdmitted, 
	A.DateAccepted as DateApplied, A.birthdate, dbo.getStudentEmailAddress(A.StudentUID) as Email,dbo.getStudentPhoneNo(A.StudentUID) as Phone,  A.Expectedtermid, dbo.getTermText(A.ExpectedTermID) as Term,
	-- dbo.getMajorName(A.ProgramsID) as MajorName,
	dbo.isstudentenrolled(a.studentuid, a.ExpectedTermID) as Enrolled,
	dbo.isstudentregisteredFormTerm(a.studentuid, a.ExpectedTermID) as Registered, 
	Case when B.MajorDegreeID Is null then A.ProgramsID else B.MajorDegreeID end as MajorIdent,
	Case when B.MajorDegree Is null then A.Programs else B.MajorDegree end as MajorName
	into #TmpAccepted
	from cams_Student_view A
	left outer join CAMS_StudentProgram_View B
	on A.StudentUID=B.StudentUID
	and A.ExpectedTermID=B.TermCalendarID
	where A.ExpectedTermID =dbo.getTermID(@UTerm)
	and A.ProspectStatus in ('Admitted','Accepted')
	order by A.LastName

	
		select case 
			when TA.Enrolled=1 and TA.Registered=1 then 'Accepted and Registered' 
			when TA.Enrolled=1 and TA.Registered=0 then 'Accepted and Enrolled' 
			else 'Accepted Only' end as TStatus,
			 TA.* , SH.Measles, SH.Measles2, SH.Mumps, SH.Rubella,SH.ExaminedDate as PhysicalDate, SH.TBTestDate1 as PPD1, SH.TBTestDate2 as PPD2, SH.HepatitisB1,SH.HepatitisB2, SH.HepatitisB3,SH.Meningitis, SH.MeningitisType ,
			  dbo.getStudentCPRDate(TA.StudentUID) as CPR, 
				dbo.getStudentFLUDate(TA.StudentUID) as FluShot, 
				dbo.getStudentHIPAADate(TA.StudentUID) as HIPPATRNG , 
			   SH.Explanations
			into #TmpAccepted1
			from #TmpAccepted TA
			left outer  join CAMS_StudentHealth_view  SH
			on TA.StudentUID=sh.StudentUID
			where 
			Ta.ExpectedTermID=dbo.getTermID(@UTerm)
			and TA.MajorIdent=@StuMajor
		
	
		select * from #TmpAccepted1
		order by TStatus, DateAdmitted asc
   
   
	drop table #TmpAccepted1
	drop table #TmpAccepted
	


