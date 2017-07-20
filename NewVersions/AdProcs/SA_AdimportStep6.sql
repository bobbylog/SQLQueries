USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep6]    Script Date: 7/20/2017 10:27:55 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep6]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep6]    Script Date: 7/20/2017 10:27:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep6]
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

	declare @cnt int
	
	/*DROP TABLE #ACH*/

	SELECT SA1.AddressID, ADAD.StudentUID, ADAD.USERID + '@trocaire.edu' AS EMA
	INTO #ACH
	FROM Trocaire_Extra.dbo.ADADInfo ADAD
	LEFT OUTER JOIN CAMS_Enterprise.dbo.Student_Address SA1
		  ON (ADAD.StudentUID = SA1.StudentID)
	WHERE ADAD.AType = @BatchParam AND ADAD.Term IN (@TermParam)
	-- AND not (adad.studentid='A0000026468' and adad.DegreeProgram like 'general studies%')
	
	SELECT @cnt=count(StudentUID)
	FROM #ACH
	-- ORDER BY StudentUID
	
	IF @cnt > 0
	BEGIN
	
		
		UPDATE CAMS_Enterprise.dbo.Address 
		SET CAMS_Enterprise.dbo.Address.Email2 = CAMS_Enterprise.dbo.Address.Email1
		WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.AddressID = CAMS_Enterprise.dbo.Address.AddressID) AND
			  CAMS_Enterprise.dbo.Address.Email2 = ''


		UPDATE CAMS_Enterprise.dbo.Address 
		SET CAMS_Enterprise.dbo.Address.Email1 = (SELECT EMA FROM #ACH 
								WHERE #ACH.AddressID = CAMS_Enterprise.dbo.Address.AddressID)
		WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.AddressID = CAMS_Enterprise.dbo.Address.AddressID)
		

	END
	
	--SELECT ADR1.*
	--FROM CAMS_Enterprise.dbo.Address ADR1
	--WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.AddressID = ADR1.AddressID)
	--ORDER BY Email1


	--SELECT * 
	--FROM #ACH
	--ORDER BY StudentUID


	DROP TABLE #ACH

	
END

GO


