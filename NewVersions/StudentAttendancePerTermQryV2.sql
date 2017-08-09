drop table #AttendanceFacts

Select StudentID,  StudentUID, SROfferID,  Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
,count (Status) as AttStatCnt, 'P' As AType
into #AttendanceFacts
From CAMS_StudentAttendance_View 
Where 
Term = 'Sp-17'
and StudentUID=91102
and Status='Present'
group by StudentID,StudentUID,SROfferID, Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
--order by StudentID , SROfferID asc
union all
Select StudentID,  StudentUID, SROfferID,  Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
,count (Status) as AttStatCnt, 'A' As AType
--into #AttendanceFacts
From CAMS_StudentAttendance_View 
Where 
Term = 'Sp-17'
and StudentUID=91102
and Status='Absent'
group by StudentID,StudentUID,SROfferID, Term, TermCalendarID,OfferDepartment, OfferType,OfferSection, OfferName
order by StudentID , SROfferID asc


select * from #AttendanceFacts

select AF.StudentID,AF.StudentUID,AF.SROfferID, AF.Term, AF.TermCalendarID, AF.OfferDepartment, AF.OfferType,AF.OfferSection, AF.OfferName,

isnull ((
select sum(A.AttStatCnt)
from #AttendanceFacts A
where 
A.Atype='P'
and A.SROfferID=AF.SROfferID
and A.StudentUID=AF.StudentUID
group by A.StudentID,A.StudentUID,A.SROfferID, A.Term, A.TermCalendarID,A.OfferDepartment, A.OfferType,A.OfferSection, A.OfferName
),0)
As Presence
,
isnull ((select sum(B.AttStatCnt)
from #AttendanceFacts B
where 
B.Atype='A'
and B.SROfferID=AF.SROfferID
and B.StudentUID=AF.StudentUID
group by B.StudentID,B.StudentUID,B.SROfferID, B.Term, B.TermCalendarID,B.OfferDepartment, B.OfferType,B.OfferSection, B.OfferName
),0)

as Absence
into #AttTab
from #AttendanceFacts AF
group by AF.StudentID,AF.StudentUID,AF.SROfferID, AF.Term, AF.TermCalendarID,AF.OfferDepartment, AF.OfferType,AF.OfferSection, AF.OfferName


select * ,  cast(( cast(Presence as numeric (5,2)) /cast(( Absence+Presence) as numeric(5,2)) ) as numeric(5,2) ) as ParRate from #AttTab


drop table #AttendanceFacts
drop table #AttTab