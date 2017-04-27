
drop table #tmptab
drop table #NE
drop table #NE1
drop table #TmpBN

SELECT 
DISTINCT 
               TOP (100) PERCENT A.custname, A.StudentID, A.Amt, A.TransDate, A.InvoiceDate, case when A.Amt < 0 then 'CREDIT' else 'DEBIT' end as Transtype
               --, B.TransDate AS TransDateB, B.TransType, B.Description, B.ShowAmount
               into #TmpBN
FROM  dbo.JanCollectBN AS A 

--inner  JOIN
  --             dbo.JanCollectCAMS AS B ON A.Amt = B.Amount AND A.StudentID = B.SStudentID AND A.InvoiceDate = B.TransDate
ORDER BY A.TransDate

select NE.*
--distinct NE.Custname, NE.Studentid 
into #NE
FROM
(
select distinct A1.* , B.TransDate AS TransDateB, B.TransType As transtypeb, B.Description, B.ShowAmount
from #TmpBN A1
left outer join
          dbo.JanCollectCAMS AS B ON 
          A1.Amt = B.ShowAmount
          AND A1.StudentID = B.SStudentID 
          AND A1.transdate = B.TransDate 
          AND A1.transtype=b.transtype
       
) NE
WHERE NE.TransDateB is not null

select NE1.*
--distinct NE.Custname, NE.Studentid 
into #NE1
FROM
(
select distinct A1.* , B.TransDate AS TransDateB, B.TransType As transtypeb, B.Description, B.ShowAmount
from #TmpBN A1
left outer join
          dbo.JanCollectCAMS AS B ON 
          A1.Amt = B.ShowAmount
          AND A1.StudentID = B.SStudentID 
          AND A1.invoicedate = B.TransDate 
          AND A1.transtype=b.transtype
       
) NE1
WHERE NE1.TransDateB is not null

--WHERE NE.TransDateB is null
select * 
into #tmptab
from #Ne
union
select * from #ne1


-----null

select distinct StudentId, custname from dbo.JanCollectBN
where StudentId not in
(
select distinct StudentId from #tmptab
)

drop table #tmptab
drop table #NE
drop table #NE1
drop table #TmpBN
