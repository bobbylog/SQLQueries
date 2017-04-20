DECLARe @Token int
DECLARe @nc int
DECLARE @dt datetime
DECLARE @cdt varchar(108)
DECLARE @Tm varchar(25)

declare @topic varchar(300)
declare @tbody varchar(300)


set @Token=0
set @dt=GETDATE()
set @cdt=convert(varchar(10), GETDATE(), 108)
set @Tm='SP-17'

-- 2 Weeks Term Shaphots

If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 0
	
		set @topic='2 Weeks snapshot Captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= 'Dear Nicole, '+CHAR(13)+CHAR(13)+CHAR(10)+'The 2 weeks snapshot has been captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '


		-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='TROCMAIL',
		@recipients = 'TomaselloN@Trocaire.edu;etiennes@trocaire.edu', 
		@subject = @topic ,
		@body = @tbody ; 
	
END

-- First Day Snapshot

If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 1


		set @topic='First Day snapshot Captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= 'Dear Nicole, '+CHAR(13)+CHAR(13)+CHAR(10)+'The First Day snapshot has been captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '

	
		-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='TROCMAIL',
		@recipients = 'TomaselloN@Trocaire.edu;etiennes@trocaire.edu', 
		@subject = @topic ,
		@body = @tbody ; 
	
END


-- Drop Add Snapshot

If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 2

		set @topic='Drop/Add snapshot Captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= 'Dear Nicole, '+CHAR(13)+CHAR(13)+CHAR(10)+'The Drop/Add snapshot has been captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '

	
		-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='TROCMAIL',
		@recipients = 'TomaselloN@Trocaire.edu;etiennes@trocaire.edu', 
		@subject = @topic ,
		@body = @tbody ; 
		
END

-- Term Snapshot / Official Snapshot

If (MONTH(@dt)=01 and DAY(@dt)=15 aND YEAR(@dt)=2015)
BEGIN
	Exec dbo.TCC_Sem_Data_SnapshotV2 @Tm, 3

		set @topic='Official snapshot Captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
		set @tbody= 'Dear Nicole, '+CHAR(13)+CHAR(13)+CHAR(10)+'The Official snapshot has been captured for '+@tm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
        CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '

	
	-- Send an email
		EXEC msdb.dbo.sp_send_dbmail 
		@profile_name='TROCMAIL',
		@recipients = 'TomaselloN@Trocaire.edu;etiennes@trocaire.edu', 
		@subject = @topic ,
		@body = @tbody ;  

END

	

