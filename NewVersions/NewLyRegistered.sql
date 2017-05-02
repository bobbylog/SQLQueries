--select * from Student where
--LastName='coker'

--select * from SRAcademic
--where StudentUID=56392

select distinct studentuid
--, TermCalendarid 
from SRAcademic where TermCalendarID=615
and studentuid not in 
(
select distinct sr.studentuid from sracademic sr
inner join TermCalendar tc1
on SR.TermCalendarID=TC1.TermCalendarID
 where tc1.Term <dbo.getTermOrdSeq(615)
)