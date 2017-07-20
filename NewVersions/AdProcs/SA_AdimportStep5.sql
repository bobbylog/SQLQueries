USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep5]    Script Date: 7/20/2017 10:27:36 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep5]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep5]    Script Date: 7/20/2017 10:27:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep5]
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
	
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>

SELECT SP1.PortalHandle, SP1.PortalPassword, SP1.PortalEnable, 
       ADAD.StudentUID, ADAD.USERID, ADAD.Password
INTO #ACH
FROM Trocaire_Extra.dbo.ADADInfo ADAD
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal SP1
      ON (ADAD.StudentUID = SP1.StudentUID)
WHERE ADAD.AType = @BatchParam AND ADAD.Term in (@TermParam)
--AND not (adad.studentid='A0000026468' and adad.DegreeProgram like 'general studies%')
ORDER BY ADAD.USERID

--SELECT #ACH.*, CAMS_Enterprise.dbo.StudentPortal.*
--FROM #ACH
--LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal 
--      ON #ACH.USERID = CAMS_Enterprise.dbo.StudentPortal.PortalHandle
--ORDER BY #ACH.PortalHandle 


SELECT @cnt=count(#ACH.USERID) FROM #ACH
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal 
      ON #ACH.USERID = CAMS_Enterprise.dbo.StudentPortal.PortalHandle
-- ORDER BY #ACH.PortalHandle 

IF @cnt > 0
	BEGIN
	
		UPDATE CAMS_Enterprise.dbo.StudentPortal 
		SET CAMS_Enterprise.dbo.StudentPortal.PortalEnable = 'Yes'
		WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)


		UPDATE CAMS_Enterprise.dbo.StudentPortal 
		SET CAMS_Enterprise.dbo.StudentPortal.PortalHandle = (SELECT USERID FROM #ACH 
											WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)
		WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)
		     

		UPDATE CAMS_Enterprise.dbo.StudentPortal 
		SET CAMS_Enterprise.dbo.StudentPortal.PortalPassword = (SELECT Password FROM #ACH 
											WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)
		WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)
	
	END

--SELECT *
--FROM CAMS_Enterprise.dbo.StudentPortal
--WHERE EXISTS (SELECT #ACH.* FROM #ACH WHERE #ACH.StudentUID = CAMS_Enterprise.dbo.StudentPortal.StudentUID)






DROP TABLE #ACH


	
END

GO


