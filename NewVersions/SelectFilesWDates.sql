create table #files (name varchar(500))

insert into #files
EXEC xp_cmdshell 'dir d:\camsenterprise\*.exe';

select name, REVERSE(SUBSTRING(REVERSE(name),0,CHARINDEX(' ',REVERSE(name)))) 
from #files 
     -- dates start with numeric --check assumption carefully...
     where isnumeric(left(name,1))=1 
       --order by date desc       --
    order by CAST(left(name,17) as datetime) desc

	drop table #files