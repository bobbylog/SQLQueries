--drop table ctm_AccomodationReqBak
select *
 --into ctm_AccomodationReqBak
from CTM_AccomodationReq
order by FormID desc

--delete from CTM_AccomodationReq
--where studid='C0000032870'