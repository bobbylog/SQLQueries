--drop table #tmp1
--select * from CAMS_RptSROfferSchedule_View order by OfferTimeFrom desc

--select distinct OfferTimeFrom, OfferTimeTo from CAMS_RptSROfferSchedule_View

select distinct SROfferID, CONVERT(VARCHAR(5),OfferTimeFrom,108) as OffTimeF, CONVERT(VARCHAR(5),OfferTimeTo,108) as OffTimeT into #tmp1 from CAMS_RptSROfferSchedule_View 
WHERE RoomAbbreviation <> 'OFF' and RoomAbbreviation <>''

select A.SROfferID, A.OffTimeF, A.OffTimeT , B.TermCalendarID
into #tmp2
from #tmp1 A inner join SROffer B ON A.srofferid=B.srOfferID
where B.TermCalendarID=614
order by A.OffTimeF asc
select * from #tmp2

select MIN (OffTimeF) from #tmp2
where OffTimeF > '06:00'

select MAX (OffTimeT) from #tmp2
where OffTimeF > '06:00'


--(select srofferid, termcalendar from SROffer) B


--on A.s

--order by OffTimeF asc


--where CONVERT(VARCHAR(5),OfferTimeFrom,108)>0
--select distinct max(OfferTimeTo) from CAMS_RptSROfferSchedule_View where YEAR(OfferTimeTo)=2017




drop table #tmp2
drop table #tmp1

