drop table #TmpSP17List
drop table #TmpAboutHours

SELECT DISTINCT 
               TOP (100) PERCENT 
               TC1.TextTerm AS Term, 
               ST1.StudentUID,
               ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName)) AS LastName, 
               LTRIM(RTRIM(ST1.FirstName)) AS FirstName, 
               ST1.MiddleInitial, 
               MM1.MajorMinorName AS DegreeProgram,
               --SP1.AdvisorID
               (select A.Firstname+' '+A.LastName from advisors A where A.advisorid=SP1.AdvisorID) as Advisor
               --LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) AS USERID
             --  SR1.Credits,
              --SR1.CumulativeEarned, 
               --SR1.CumulativeGPAHours,
               --SR1.*
               --,
               --dbo.getAdvisorDetailsByStudentID('sp-17',St1.StudentID,6) As Advisor
              -- case when dbo.isStudentEnrolled(St1.studentuid,616) =0 then 'No' else 'Yes' end As EnrolledFA17,
               --case when dbo.isStudentRegisteredFormTerm(St1.studentuid,616) =0 then 'No' else 'Yes' end As RegisteredFA17
into #TmpSP17List
FROM  dbo.SRAcademic AS SR1 LEFT OUTER JOIN
               dbo.TermCalendar AS TC1 ON SR1.TermCalendarID = TC1.TermCalendarID LEFT OUTER JOIN
               dbo.Glossary AS GL1 ON SR1.CategoryID = GL1.UniqueId LEFT OUTER JOIN
               dbo.Student AS ST1 ON SR1.StudentUID = ST1.StudentUID LEFT OUTER JOIN
               dbo.StudentStatus AS SS1 ON SR1.StudentUID = SS1.StudentUID AND SR1.TermCalendarID = SS1.TermCalendarID LEFT OUTER JOIN
               dbo.StudentProgram AS SP1 ON SS1.StudentStatusID = SP1.StudentStatusID LEFT OUTER JOIN
               dbo.MajorMinor AS MM1 ON SP1.MajorProgramID = MM1.MajorMinorID
WHERE (TC1.TextTerm = 'SP-17') 
--AND (NOT (GL1.DisplayText = 'Transfer')) 
AND (NOT (ST1.LastName = 'Testperson'))
ORDER BY LastName, FirstName



select SP.*  from #TmpSP17List SP


--select StudentUID, sum(Credits) as TotalCreditHours, sum(CumulativeEarned) as TotalCreditsEarned, sum(CumulativeGPAHours) as TotalGPAHours
--into #TmpAboutHoursWTR

--from SRAcademic where 
--StudentUID in 
--(select studentuid from #TmpSP17List)
----and TermCalendarID=614
----and StudentUID=120434
--and Grade ='TR'
--group by StudentUID
--order by StudentUID

--select StudentUID, sum(Credits) as TotalCreditHours, sum(CumulativeEarned) as TotalCreditsEarned, sum(CumulativeGPAHours) as TotalGPAHours
--into #TmpAboutHoursNoTR

--from SRAcademic where 
--StudentUID in 
--(select studentuid from #TmpSP17List)
----and TermCalendarID=614
----and StudentUID=120434
--and Grade <>'TR'
--group by StudentUID
--order by StudentUID


--select 
--*,
--case when dbo.isStudentEnrolled(Ta.StudentUID,616) =0 then 'No' else 'Yes' end As EnrolledFA17,
-- case when dbo.isStudentRegisteredFormTerm(Ta.StudentUID,616) =0 then 'No' else 'Yes' end As RegisteredFA17 
--from 
--#TmpSP17List TS
--left outer join
--#TmpAboutHours TA
--on 
--TA.StudentUID=TS.StudentUID

--select * from 
--#TmpAboutHoursWTR
--where StudentUID=120434
 select *,  
 isnull([dbo].[getSumTransferCreditsAll] (StudentUID),0) As CumTransferCredits,
 isnull([dbo].[getSumTransferCreditsPerTerm] (StudentUID,614),0) as TermTransferCredits,
 isnull([dbo].[getSumTrocaireEarnedCreditsAll] (StudentUID),0) as TrocCumEarnedCredits,
 isnull([dbo].[getSumTrocaireEarnedCreditsPerTerm] (StudentUID,614),0) as TrocTermEarnedCredits,
 ISNULL([dbo].[getSumTrocaireCreditsTakenAll] (StudentUID),0) as CumCreditsTaken,
 isnull([dbo].[getSumTrocaireCreditsTakenPerTerm] (StudentUID,614),0) as TermsCreditsTaken,
 case when dbo.isStudentEnrolled(StudentUID,616) =0 then 'No' else 'Yes' end As EnrolledFA17,
 case when dbo.isStudentRegisteredFormTerm(StudentUID,616) =0 then 'No' else 'Yes' end As RegisteredFA17 

 
 from #TmpSP17List
 

--Graduate of May 2017
--select StudentUID, dbo.getStudentFullName(dbo.getStudentIDFromUID(StudentUID)) as StudentFullName, dbo.getMajorName(MajorID1) as MajorName
--from studentDegree
--where month(graduationdate)=05
--and YEAR(graduationdate)=2017

--drop table #TmpAboutHours
drop table #TmpSP17List