USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep8]    Script Date: 7/20/2017 10:28:33 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep8]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep8]    Script Date: 7/20/2017 10:28:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep8]
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @cnt int
	
	Select @cnt=count(Term) 
	From Trocaire_Extra.dbo.ADADinfo 
	Where Not Password='99999999'
	
	IF @cnt >0 
	BEGIN

		Update Trocaire_Extra.dbo.ADADinfo 
		Set Password='99999999'
		Where Not Password='99999999'

	END

	
END

GO


