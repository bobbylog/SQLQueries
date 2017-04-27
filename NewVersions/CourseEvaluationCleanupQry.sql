--drop table #tmpresp


select * 
into #tmpResp
from dbo.CrsEvalResponse
where 
MONTH(datesubmitted)=4
and DAY(datesubmitted)=19
and YEAR(datesubmitted)=2017
and OwnerUID=110010
--and SROfferid=100479
order by EvalRespID desc




select * from #tmpresp




delete from dbo.CrsEvalResponse
where 
MONTH(datesubmitted)=4
and DAY(datesubmitted)=19
and YEAR(datesubmitted)=2017
and OwnerUID=110010
and EvalRespID in (select Evalrespid from #tmpresp)


drop table #tmpresp