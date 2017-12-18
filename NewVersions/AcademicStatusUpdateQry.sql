--select * from StudentStatus
--where AcademicStatusID >0

create table #TmpStatus(
	StudentUID varchar(25),
	Status varchar(25)
)
insert into #TmpStatus
exec dbo.CTM_DetermineStudentProbationStatusByTermAll 'FA-17'

--select * from CAMS_StudentStatus_View
--where AcademicStatusID >0

--select * from StatusCode

select distinct TP.* , 
case 
when TP.Status='Probation' then 2 
when TP.Status='Dismissal' then 1
end as SCode
into #TmpStatus1
from #TmpStatus TP

select * from #TmpStatus1

----select distinct studentuid, AcademicStatusID from CAMS_StudentStatus_View
----where
----TermCalendarID=616
----order by StudentUID asc

-- Probation
--update StudentStatus 
--set AcademicStatusID=2
--where Studentuid in
--(select distinct * from #TmpStatus1 where Status='Probation')

-- Dimissed

--update StudentStatus 
--set AcademicStatusID=1
--where Studentuid in
--(select distinct * from #TmpStatus1 where Status='Dismissal')

-- Good Standing

--update StudentStatus 
--set AcademicStatusID=8
--where Studentuid NOT in
--(select distinct * from #TmpStatus1 where Status='Dismissal')
-- and AcademicStatusID <> 8



-- AcademicStatusID >0

drop table #TmpStatus
drop table #TmpStatus1