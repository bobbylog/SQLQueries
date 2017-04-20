--insert into #tmpdirectory
IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\CAMSEnterprise\TCC\',1,1;

select * 
into #tmpRpt
from #tmpDirectory
where subdirectory like '%.rpt'
order by subdirectory asc

select subdirectory from #tmpRpt

drop table #tmpRpt
drop table #tmpdirectory
