--drop table #TmpDropped
--drop table #TmpBag
--drop table #TmpEnroll


create table #TmpEnroll (
 action varchar(25),
 CourseID varchar(100),
 UserID varchar(50),
 role varchar(50),
 Status int
)

insert into #TmpEnroll
Exec [dbo].[Conduit_getEnrollList]


--drop table dbo.TmpMoodleEnrollHistory
--select * into dbo.TmpMoodleEnrollHistory from #TmpEnroll

----select * from dbo.TmpMoodleEnrollHistory

select A.action, A.CourseID, isnull(A.UserID,0) as UserID , A.role, A.Status, 
--to use on first day of semester switch
isnull ( (select top 1 TP.UserID from #TmpEnroll TP where TP.CourseID=A.CourseID and TP.UserID=A.UserID and role='editingteacher') , 0 ) as FacCurrent 
--used after 1st time
--isnull ( (select top 1 TP.UserID from #TmpEnroll TP where TP.CourseID=A.CourseID and TP.UserID=A.UserID and role='editingteacher') , 0 ) as FacCurrent 
into #TmpBag
from dbo.TmpMoodleEnrollHistory A
where A.role='editingteacher'

select *, case when UserID=FacCurrent then 0 else 1 end  as Changed 
into #TmpDropped
from #TmpBag

select * , ( dbo.getFacultyFullName(UserID,3)+' dropped from '+CourseID ) as DropFac from #TmpDropped
where Changed=1






--select A.*,A.UserID as HistFacA, B.UserID as CurFacB , case when A.UserID=B.UserID then 0 else 1 end as Changed  from dbo.TmpMoodleEnrollHistory A
--inner join #TmpEnroll B 
--ON A.CourseID=B.CourseID
--where 
--a.role='editingteacher'
--and b.role='editingteacher'
--order by A.CourseID

--except
--select * from #TmpEnroll

drop table #TmpDropped
drop table #TmpBag
drop table #TmpEnroll