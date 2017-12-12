select * from AdvPortalAlerts
where TTerm='FA-17'

select CourseID , Coursename, FacultyID, dbo.getFacultyFullName(FacultyID,3) as FacultyName, Count(AlertID) as NumAlertSubmitted , 
SUM(CASE WHEN Tutoring='Yes' THEN 1 ELSE 0 END) as TutoringRecom
into #AlertFacts
from AdvPortalAlerts
where TTerm='FA-17'
GROUP BY CourseID , Coursename, FacultyID

select CourseID, FacultyName, NumAlertSubmitted, TutoringRecom from #AlertFacts
order by FacultyName, CourseID, CourseName asc

drop table #AlertFacts