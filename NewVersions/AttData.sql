drop table #AttData

select Status , Day(SADate) dAtt, Datename(dw, SADate) as DName
into #AttData
From CAMS_StudentAttendance_View
where TermCalendarID=616
and srofferid=100766
--and SrofferScheduleID=15078

select dAtt, DName,Count(Status) as AttNum from #AttData
where Status='Present'
Group by dAtt, DName

drop table #AttData