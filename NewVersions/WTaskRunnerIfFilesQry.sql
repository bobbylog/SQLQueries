
DECLARe @Token int
DECLARe @nc int
DECLARE @dt datetime
DECLARE @cdt varchar(108)

declare @topic varchar(300)
declare @tbody varchar(300)

set @Token=0
set @dt=GETDATE()
set @cdt=convert(varchar(10), GETDATE(), 108)

-- If time between 10:52 and 11:08:00
--if (@cdt between '10:52:00' and '11:10:00')
  --EXEC  master..xp_cmdshell 'schtasks /run /tn Testscr'

--select @Token as TOK

IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
      DROP TABLE #tmpDirectory;

CREATE TABLE #tmpDirectory (
       id int IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #tmpDirectory (subdirectory,depth,isfile)
EXEC master.sys.xp_dirtree 'D:\SFTP\keybank\Exports\',1,1;


select @nc=COUNT(subdirectory) 
from #tmpDirectory
where isfile=1

if (@nc >0)
    begin

	    EXEC  master..xp_cmdshell 'schtasks /run /tn WinscpKeybankSync'
  
    end

DROP TABLE #tmpDirectory;
