select * 
--into #tscb
from dbo.testScoreBatch
order by BNum desc

--update dbo.testScoreBatch set released=1
--where BNum=17 and (OwnerUID is null or OwnerUID =0)
--select *, 0 as released 
--into dbo.testScorebatch1
--from #tscb
--drop table dbo.testScoreBatch1
--select * 
--into dbo.testScoreBatch
--from dbo.testScorebatch1





--drop table #tscb
