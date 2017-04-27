select A.StudentID, A.LastName, A.firstname, A.Expectedtermid, A.ProspectStatus,
dbo.isstudentenrolled(a.studentuid, a.ExpectedTermID) as Enrolled,
dbo.isstudentregisteredFormTerm(a.studentuid, a.ExpectedTermID) as Registered, B.MajorDegree
into #TmpAccepted
from cams_Student_view A
left outer join CAMS_StudentProgram_View B
on A.StudentUID=B.StudentUID
and A.ExpectedTermID=B.TermCalendarID

where A.ExpectedTermID =616
and A.ProspectStatus in ('Admitted','Accepted')


order by A.LastName

select * from #TmpAccepted
where Enrolled=0 and Registered=0

drop table #TmpAccepted