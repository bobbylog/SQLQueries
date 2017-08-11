use CAMS_Enterprise



-- Exporting  File

	DECLARE @cmdstr nvarchar(max)
	DECLARE @tmstp varchar(15)
	DECLARE @globalcmdstr varchar(1000)
	DECLARE @cterm varchar(15)
	DECLARE @filename1 nvarchar(300)

				
	--set @cmdstr= 'SQLCMD -h-1 -S trocaire-sql01 -E  -s, -W -Q "set nocount on; EXEC CAMS_Enterprise.dbo.GenerateTmpfStuExport2"  > D:\CAMSEnterprise\TMPGMExport\GMData'
	set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; EXEC CAMS_Enterprise.dbo.CTM_Generate_FA_Accept_Rpt"  > D:\CAMSEnterprise\Finaid\FA_Accept'
	set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
	set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
	set @filename1='D:\CAMSEnterprise\Finaid\FA_Accept_'+@tmstp+'.csv'

	--print @globalcmdstr
	EXEC  master..xp_cmdshell 'del /F /Q D:\CAMSEnterprise\Finaid\*.*'
	EXEC  master..xp_cmdshell @globalcmdstr

				
	declare @glfile varchar(max)
	declare @topic varchar(300)
	declare @tbody varchar(300)
	set @topic='FA_Accept was executed at '+CONVERT(VARCHAR, GETDATE())
	set @glfile=@filename1
	set @tbody= 'Dear Financial Aid Office, '+CHAR(13)+CHAR(13)+CHAR(10)+'Here is today''s report. Report any issues, problems, or questions to helpdesk@trocaire.edu.'			+CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '


	-- Send an email
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='TROCMAIL',
	@recipients = 'germonoa@trocaire.edu;adamczykt@trocaire.edu;smithj@trocaire.edu;CooksC@Trocaire.edu;LucasJ@Trocaire.edu;', 
	@copy_recipients='etiennes@trocaire.edu',
	@file_attachments =@glfile,
	-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
	@subject = @topic ,
	@body = @tbody ;  



	
	
	
