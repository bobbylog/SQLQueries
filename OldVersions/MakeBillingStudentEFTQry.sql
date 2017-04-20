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
           ,'111830'
           ,'PRIMARY'
           ,'111830'
           ,1
           ,31
           ,0
           ,0
           ,0
           ,0
           ,1
           ,1
           ,GETDATE()
           ,GETDATE()
         )  
GO


