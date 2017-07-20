USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep2]    Script Date: 7/20/2017 10:25:46 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep2]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep2]    Script Date: 7/20/2017 10:25:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep2]
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
	@TermParam varchar(12),
	@BatchParam varchar(15)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
	DECLARE @cnt int
	DECLARE @name varchar(15)
	DECLARE @name1 varchar(15)

	Select @cnt=STUDENTUID from dbo.SA_tmpADImporttbl where ADCEUN <> '' or ADsAMUN <> '' OR  ADCEID <>''
		IF @cnt >0
		BEGIN

				DECLARE db_cursor CURSOR FOR  
				select STUDENTUID, USERID from dbo.SA_tmpADImporttbl where ADCEUN <> '' or ADsAMUN <> '' OR  ADCEID <>''
				-- IF count >0 then

				OPEN db_cursor   
				FETCH NEXT FROM db_cursor INTO @name , @name1 

				WHILE @@FETCH_STATUS = 0   
				BEGIN   
					   -- select @name, @name1, dbo.SA_CheckADId(@name1)
				       
						UPDATE Trocaire_Extra.dbo.ADADInfo
						SET USERID = dbo.SA_CheckADId(@name1)
						WHERE Term in (@TermParam) AND AType = @BatchParam AND StudentUID = @name

					   FETCH NEXT FROM db_cursor INTO @name , @name1  
				END   

				CLOSE db_cursor   
				DEALLOCATE db_cursor
		END	
	
	
END

GO


