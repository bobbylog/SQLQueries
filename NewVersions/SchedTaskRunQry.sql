-- EXEC  master..xp_cmdshell 'schtasks /run /tn Testscr'

DECLARe @Token int
DECLARe @nc int
DECLARE @dt datetime
DECLARE @cdt varchar(108)

set @Token=0
set @dt=GETDATE()
set @cdt=convert(varchar(10), GETDATE(), 108)

-- If time between 10:52 and 11:08:00
if (@cdt between '10:52:00' and '11:10:00')
  EXEC  master..xp_cmdshell 'schtasks /run /tn Testscr'

--select @Token as TOK