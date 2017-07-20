USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep4]    Script Date: 7/20/2017 10:26:50 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep4]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep4]    Script Date: 7/20/2017 10:26:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep4]
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
DROP TABLE  SA_tmpADFinalMailMerge   
SELECT AI.StudentID, AI.LastName, AI.FirstName, AI.MiddleInitial, AI.UserID, 
       case
           WHEN AI.AType IN ('Original') THEN 'The last four digits of your Social Security Number'
           When AI.AType IN (@BatchParam)    Then AI.Password
        end AS Npassword,
       AI.Password, ATYPE,
       ADR1.Address1 + ' ' + ADR1.Address2 + ' ' + ADR1.Address3 AS Address,
       ADR1.City + ', ' + GL3.DisplayText + '  ' + ADR1.ZipCode AS CSZ
INTO  SA_tmpADFinalMailMerge      
From Trocaire_Extra.dbo.ADADInfo AI
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student_Address STA1
       ON (AI.StudentUID = STA1.StudentID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
       ON (STA1.AddressID = ADR1.AddressID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL2
       ON (ADR1.AddressTypeID = GL2.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL3
       ON (ADR1.StateID = GL3.UniqueId)
WHERE GL2.DisplayText = 'Local' AND ADR1.ActiveFlag = 'Yes' AND
      (AI.AType IN (@BatchParam, 'Original1')) AND AI.Term IN (@TermParam)
ORDER BY AI.AType, AI.LastName, AI.FirstName, AI.MiddleInitial

	
END

GO


