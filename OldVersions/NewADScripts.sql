declare @cnt int
declare @nc int
declare @batchnum int
declare @Newbatch varchar(25)
DECLARE @cmdstr varchar(200)
DECLARE @tmstp varchar(15)
DECLARE @globalcmdstr varchar(215)
DECLARE @cterm varchar(15)
DECLARE @filename1 nvarchar(300)
DECLARE @filename2 nvarchar(300)
DECLARE @filename3 nvarchar(300)
DECLARE @filename4 nvarchar(300)


set @cterm='FA-16'

	 Exec dbo.SA_ADGenerateBatchNum @cterm
	 set @batchnum = dbo.SA_getADNewBatchNum()
	 set @Newbatch='New'+ CONVERT(VARCHAR, @batchnum)
	 EXEC dbo.SA_AdimportStep1 @cterm

	select @nc=count(Term) from dbo.SA_tmpADImporttbl

		IF @nc >0
		BEGIN

				 EXEC dbo.SA_AdimportStep1_Build @cterm, @Newbatch 
				 EXEC dbo.SA_AdimportStep2 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep3 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep4 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep5 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep6 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep7 @cterm, @Newbatch
				 EXEC dbo.SA_AdimportStep8
				

				-- Exporting Main AdImport File
				set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.SA_tmpADFinalAdImport"  > D:\CAMSEnterprise\AdImports\AdImport'
				set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
				set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
				set @filename1='D:\CAMSEnterprise\AdImports\AdImport_'+@tmstp+'.csv'
				EXEC  master..xp_cmdshell @globalcmdstr

				-- Exporting Password File
				set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.SA_tmpADFinalPasswordFile"  > D:\CAMSEnterprise\AdImports\PasswordFile'
				set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
				set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
				set @filename2='D:\CAMSEnterprise\AdImports\PasswordFile_'+@tmstp+'.csv'
				EXEC  master..xp_cmdshell @globalcmdstr
				
				-- Exporting Mailmerge File
				set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.SA_tmpADFinalMailMerge"  > D:\CAMSEnterprise\AdImports\MailMerge'
				set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
				set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
				set @filename3='D:\CAMSEnterprise\AdImports\MailMerge_'+@tmstp+'.csv'
				EXEC  master..xp_cmdshell @globalcmdstr
				
				-- Exporting Moodleusers File
				set @cmdstr= 'SQLCMD -S trocaire-sql01 -E  -s, -W -Q "set nocount on; Select * from CAMS_Enterprise.dbo.SA_tmpADFinalMoodleUsers"  > D:\CAMSEnterprise\AdImports\MoodleUsers'
				set @tmstp=LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
				set @globalcmdstr = @cmdstr+'_'+@tmstp+'.csv'
				set @filename4='D:\CAMSEnterprise\AdImports\MoodleUsers_'+@tmstp+'.csv'
				EXEC  master..xp_cmdshell @globalcmdstr
				
				declare @glfile nvarchar(max)
				declare @topic varchar(300)
				declare @tbody varchar(300)
				set @topic='AdImport Files for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)
				set @glfile=@filename1+ ';'+@filename2+';'+@filename3+';'+@filename4
				set @tbody= 'Barb / Robin, '+CHAR(13)+CHAR(13)+CHAR(10)+'Please, find Attached AdImport Files for '+@cterm+ ' as of '+LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10)+
				            CHAR(13)+CHAR(13)+CHAR(10)+'Regards, '+CHAR(13)+CHAR(13)+CHAR(10)+'Senghor E '
				
				-- Send an email
				EXEC msdb.dbo.sp_send_dbmail 
				@profile_name='TROCMAIL',
				@recipients = 'etiennes@trocaire.edu', 
				@file_attachments =@glfile,
				-- @query = 'SELECT * FROM CAMS_ENTERPRISE.dbo.tmpStudentStatHistory WHERE DAY(SDATE)=DAY(GETDATE()) AND MONTH(SDATE)=MONTH(GETDATE()) AND YEAR(SDATE)=YEAR(GETDATE())',
				@subject = @topic ,
				@body = @tbody ;  
				
		
				-- Cleaning up
				delete from tmpADImporttbl
				delete from tmpADFinalAdImport
				delete from tmpADFinalPasswordFile
				delete from tmpADFinalMailMerge
				delete from tmpADFinalMoodleUsers	
			
			

		END