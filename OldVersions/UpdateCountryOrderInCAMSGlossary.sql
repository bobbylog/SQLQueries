-- drop table #tmpGloss
select * , ROW_NUMBER() OVER(ORDER BY Displaytext ASC) AS Row 
INTO #tmpGloss
from Glossary

where Category=1002
and uniqueid <>3063 and uniqueid <>3234
-- Description in ('albania', 'africa','argentina')

order by DisplayText ASC

update #tmpGloss set ElementNo=Row

-- delete from Glossary where UniqueId=3411 and Category=1002 and ElementNo=147
select * from #tmpGloss



update Glossary set 
Glossary.ElementNo=tGL.ElementNo
FROM
    Glossary GL1
INNER JOIN
    #tmpGloss tGL
ON 
    GL1.UniqueId =tGL.UniqueId
WHERE
    GL1.Category=1002    

select *
from Glossary
where Category=1002
and uniqueid <>3063 and uniqueid <>3234
order by DisplayText

-- delete from Glossary where UniqueId=1971 and Category=1002 and ElementNo=172
update Glossary set DisplayText='Sudanese', Description='Sudanese' where UniqueId=1971 and Category=1002 and ElementNo=172
drop table #tmpGloss