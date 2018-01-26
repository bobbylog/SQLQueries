select distinct studentid, Lastname, firstname, DegreeProgram
into #tmptab
from Trocaire_Extra.dbo.Troc_Term_Snapshots_First_Day1
group by studentid, Lastname, firstname, DegreeProgram
order by lastname,firstname asc

select studentid, Lastname, firstname, count(studentid) as cnt 
into #tmptab1
from #tmptab
group by studentid, Lastname, firstname
having count(studentid) >1
order by lastname,firstname asc

select  distinct studentid, Lastname, firstname, DegreeProgram, sequenceNo from Trocaire_Extra.dbo.Troc_Term_Snapshots_First_Day1
where studentid in(
select studentid from #tmptab1)
and 
studentid in
(
'A0000015526',
'A0000024499',
'A0000024742',
'A0000022282'
)
order by lastname, firstname asc



--update Trocaire_Extra.dbo.Troc_Term_Snapshots_First_Day1
--set sequenceno=1 where 
--studentid in
--(
--'A0000015526',
--'A0000024499',
--'A0000024742',
--'A0000022282'
--)
--and degreeprogram='General Studies'


drop table #tmptab
drop table #tmptab1