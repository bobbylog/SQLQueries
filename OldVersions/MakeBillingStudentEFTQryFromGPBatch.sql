/****** Script for SelectTopNRows command from SSMS  ******/

  
    declare @nc int
   declare @cnt int
   declare @Res varchar(15)
   declare @handle varchar(15)
   declare @Avail int
   declare @i int
   
   set @nc=0
   set @i=1
   set @Avail=0

SELECT distinct @cnt=count([VENDORID])
  FROM [TC].[dbo].[PM10000]
  WHERE [BACHNUMB]='AP2016-09-21A'
  -- AND VENDORID IN(113587,113700)
 AND VENDORID NOT IN(115326,113402,107112,120050,111830, 113587,113700)

insert into tc.dbo.tmpVendorEfthistory(vendorid, dateeftinsert)
SELECT distinct [VENDORID], GETDATE() as dateeftinsert
  FROM [TC].[dbo].[PM10000]
  WHERE [BACHNUMB]='AP2016-09-21A'
  -- AND VENDORID IN(113587,113700)
 AND VENDORID NOT IN(115326,113402,107112,120050,111830, 113587,113700)


IF @cnt >0
BEGIN

		DECLARE db_cursor CURSOR FOR  
		SELECT distinct [VENDORID]
		FROM [TC].[dbo].[PM10000]
		WHERE [BACHNUMB]='AP2016-09-21A' 
		-- AND VENDORID IN(113587,113700)
		AND VENDORID NOT IN(115326,113402,107112,120050,111830, 113587,113700)
		
		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @handle 

		WHILE @@FETCH_STATUS = 0
		BEGIN   
		       print @handle
		       
		       INSERT INTO [TC].[dbo].[SY06000]
           ([SERIES]
      ,[CustomerVendor_ID]
      ,[ADRSCODE]
      ,[VENDORID]
      ,[EFTUseMasterID]
      ,[EFTBankType]
      ,[FRGNBANK]
      ,[INACTIVE]
      ,[GIROPostType]
      ,[BankInfo7]
      ,[EFTTransferMethod]
      ,[EFTAccountType]
      ,[EFTPrenoteDate]
      ,[EFTTerminationDate])
     VALUES
           (4
           ,@handle
           ,'PRIMARY'
           ,@handle
           ,1
           ,31
           ,0
           ,0
           ,0
           ,0
           ,1
           ,1
           ,'1900-01-01 00:00:00.000'
           ,'1900-01-01 00:00:00.000'
         )  
		       
			   FETCH NEXT FROM db_cursor INTO @handle
		END   


		CLOSE db_cursor   
		DEALLOCATE db_cursor


END



