 drop table #TBCurTerm
  drop table #TBNextTerm
   drop table #TBCurActive
  drop table #TBNextActive
  
SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
into #TBNextTerm
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = 'Fa-16')
                  AND dbo.EnrollmentStatus.EnrollmentStatusID <>2 -- Continuing
                    -- AND dbo.EnrollmentStatus.EnrollmentStatusID <>27 -- Transfer
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>1 -- Alumni
                    AND dbo.EnrollmentStatus.Status NOT LIKE '%Freshman%'
 
select *, dbo.isStudentRegisteredForClassesForTermByID('fa-16', #TBNextTerm.StudentUID) as Inclass  
Into #TBNextActive
from #TBNextTerm


SELECT  dbo.studentstatus.StudentStatusID, dbo.StudentStatus.StudentUID, dbo.EnrollmentStatus.Status, dbo.EnrollmentStatus.EnrollmentStatusID
into #TBCurTerm
FROM  dbo.TermCalendar INNER JOIN
               dbo.StudentStatus ON dbo.TermCalendar.TermCalendarID = dbo.StudentStatus.TermCalendarID INNER JOIN
               dbo.EnrollmentStatus ON dbo.StudentStatus.EnrollmentStatusID = dbo.EnrollmentStatus.EnrollmentStatusID
WHERE (dbo.TermCalendar.ActiveFlag = 'True') AND (dbo.TermCalendar.TextTerm = 'su-16')
                  AND dbo.EnrollmentStatus.EnrollmentStatusID <>2 -- Continuing
                    -- AND dbo.EnrollmentStatus.EnrollmentStatusID <>27 -- Transfer
                    AND dbo.EnrollmentStatus.EnrollmentStatusID <>1 -- Alumni
                    AND dbo.EnrollmentStatus.Status NOT LIKE '%Freshman%'
 
select *, dbo.isStudentRegisteredForClassesForTermByID('su-16', #TBCurTerm.StudentUID) as Inclass  
into #TBCuractive
from #TBCurTerm

drop table dbo.tmpStudentStatHistory
-- Insert into dbo.tmpStudentStatHistory
select *, GETDATE() AS SDATE, dbo.isStudentGraduated(StudentUID, 'su-16') as Graduated 
into dbo.tmpStudentStatHistory
from #TBNextActive where #TBNextActive.Inclass>0 aND  #TBNextactive.StudentUID in (
select distinct #TBCuractive.StudentUID from #TBCuractive where #TBCuractive.Inclass >0)



  drop table #TBCurTerm
  drop table #TBNextTerm
   drop table #TBCurActive
  drop table #TBNextActive