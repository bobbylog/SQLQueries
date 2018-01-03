--select * from StudentStatus
--where AcademicStatusID >0
--drop table #TmpStatus
--drop table #TmpStatus1




create table #TmpStatus(
	StudentUID varchar(25),
	Status varchar(25)
)
insert into #TmpStatus
exec dbo.CTM_DetermineStudentProbationStatusByTermAll 'FA-17'

--select * from CAMS_StudentStatus_View
--where AcademicStatusID >0

select * from StatusCode

select distinct TP.* , 
case 
when TP.Status='Probation' then 2 
when TP.Status='Dismissal' then 1
end as SCode
into #TmpStatus1
from #TmpStatus TP

select * from #TmpStatus1
order by Status asc

----select distinct studentuid, AcademicStatusID from CAMS_StudentStatus_View
----where
----TermCalendarID=616
----order by StudentUID asc

-- Probation
----update StudentStatus 
----set AcademicStatusID=2
----where Studentuid in
----(select distinct StudentUID from #TmpStatus1 where Status='Probation')
----and TermCalendarID=616


-- Dimissed

----update StudentStatus 
----set AcademicStatusID=1
----where Studentuid in
----(select distinct StudentUID from #TmpStatus1 where Status='Dismissal')
----and TermCalendarID=616

-- Good Standing

----update StudentStatus 
----set AcademicStatusID=8
----where Studentuid NOT in
----(select distinct StudentUID from #TmpStatus1)
----and AcademicStatusID NOT in(5,4,3,6)
----and TermCalendarID=616


-- AcademicStatusID >0

drop table #TmpStatus
drop table #TmpStatus1