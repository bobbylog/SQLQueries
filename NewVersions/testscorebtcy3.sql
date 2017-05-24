	--drop table dbo.testScoreBatch1
	
	--select OwnerUID, TestDate, TestName, Score1, Percentile, Authorized , BNum
	--into dbo.testscoreBatch1
	--											from dbo.testScoreBatch 
	--											where Authorized=1 and (owneruid is not null and owneruid >0)
	--											and BNum=23
	--											order by OwnerUID asc
	
--select * from dbo.testScoreBatch1
	select *  from cams_testscore1
	select *  from cams_testscore2
	select dbo.getStudentFullName(dbo.getStudentidfromuid(Ownerid)),* from cams_test1
	
	--delete  from cams_testscore2