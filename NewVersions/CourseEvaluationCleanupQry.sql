select * 
into #tmpResp
from dbo.CrsEvalResponse
where 
MONTH(datesubmitted)=4
and DAY(datesubmitted)=17
and YEAR(datesubmitted)=2017
and OwnerUID=627
and SROfferid=100479
order by EvalRespID desc


--select distinct * from SRAcademic
--where CourseName like 'health assessment%'
--and TermCalendarID=614



--select Evalrespid from #tmpresp




delete from dbo.CrsEvalResponse
where 
MONTH(datesubmitted)=4
and DAY(datesubmitted)=17
and YEAR(datesubmitted)=2017
and OwnerUID=627
and EvalRespID in (select Evalrespid from #tmpresp)


--drop table #tmpresp