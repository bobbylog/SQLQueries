drop table #TmpSP17List
drop table #TmpAboutHours

drop table #TmpSP18List


SELECT DISTINCT 
               TOP (100) PERCENT 
               TC1.TextTerm AS Term, 
               ST1.StudentUID,
               ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName)) AS LastName, 
               LTRIM(RTRIM(ST1.FirstName)) AS FirstName, 
               ST1.MiddleInitial, 
               MM1.MajorMinorName AS DegreeProgram,
               SS1.EnrollmentStatusID, (select e.Status from EnrollmentStatus e where e.EnrollmentStatusID=SS1.enrollmentStatusID) as Status,
			   dbo.getStudentEmailAddressFromID(ST1.StudentID) as Email,
			   dbo.getStudentPhoneNo(St1.studentUID) as PhoneNo,
               --SP1.AdvisorID
               (select A.Firstname+' '+A.LastName from advisors A where A.advisorid=SP1.AdvisorID) as AdvisorFA17
          
into #TmpSP17List
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'FA-17') 
--AND (NOT (GL1.DisplayText = 'Transfer')) 
AND (NOT (ST1.LastName = 'Testperson'))
--and SP1.SequenceNo=0
ORDER BY LastName, FirstName



------ select *,  
------ isnull([dbo].[getSumTransferCreditsAll] (StudentUID),0) As CumTransferCredits,
------ --isnull([dbo].[getSumTransferCreditsPerTerm] (StudentUID,616),0) as TermTransferCredits,
------ isnull([dbo].[getSumTrocaireEarnedCreditsAll] (StudentUID),0) as TrocCumEarnedCredits,
-------- isnull([dbo].[getSumTrocaireEarnedCreditsPerTerm] (StudentUID,616),0) as TrocTermEarnedCredits,
------ --ISNULL([dbo].[getSumTrocaireCreditsTakenAll] (StudentUID),0) as CumCreditsTaken,
-------- isnull([dbo].[getSumTrocaireCreditsTakenPerTerm] (StudentUID,616),0) as TermsCreditsTaken,
------dbo.getStudentTrocGPA (StudentUid) as CumGPA

--------,case when dbo.isStudentEnrolled(StudentUID,616) =0 then 'No' else 'Yes' end As EnrolledSP18,
--------,case when dbo.isStudentRegisteredFormTerm(StudentUID,616) =0 then 'No' else 'Yes' end As RegisteredFA17 
 
------ from #TmpSP17List
------ --Where EnrollmentStatusID=2
 


 ---Sp-18


 SELECT DISTINCT 
               TOP (100) PERCENT 
               TC1.TextTerm AS Term, 
               ST1.StudentUID,
               ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName)) AS LastName, 
               LTRIM(RTRIM(ST1.FirstName)) AS FirstName, 
               ST1.MiddleInitial, 
               MM1.MajorMinorName AS DegreeProgram,
               SS1.EnrollmentStatusID, (select e.Status from EnrollmentStatus e where e.EnrollmentStatusID=SS1.enrollmentStatusID) as Status,
			   dbo.getStudentEmailAddressFromID(ST1.StudentID) as Email,
			   dbo.getStudentPhoneNo(St1.studentUID) as PhoneNo,
               --SP1.AdvisorID
               (select A.Firstname+' '+A.LastName from advisors A where A.advisorid=SP1.AdvisorID) as AdvisorSP18
          
into #TmpSP18List
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'SP-18') 
--AND (NOT (GL1.DisplayText = 'Transfer')) 
AND (NOT (ST1.LastName = 'Testperson'))
--and SP1.SequenceNo=0
ORDER BY LastName, FirstName


select A.*
,case when dbo.isStudentEnrolled(A.StudentUID,617) =0 then 'No' else 'Yes' end As EnrolledSP18
,B.AdvisorSP18
,B.DegreeProgram as DegreeProgramSP18
,dbo.getStudentTrocGPA (B.StudentUid) as CumGPA
,isnull([dbo].[getSumTrocaireEarnedCreditsAll] (B.StudentUID),0) as TrocCumEarnedCredits

 from #TmpSP17List A
left outer join 
#TmpSP18List B ON A.StudentUID=B.StudentUID


drop table #TmpSP18List
drop table #TmpSP17List
