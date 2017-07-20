USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep7]    Script Date: 7/20/2017 10:28:16 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep7]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep7]    Script Date: 7/20/2017 10:28:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep7]
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

	DROP TABLE dbo.SA_tmpADFinalMoodleUsers 
	SELECT DISTINCT 'update' AS action,
					REPLACE(SPT.PortalHandle, '''', '') AS username,
					ST.StudentID AS SID,
					REPLACE(ADR1.Email1, '''', '') AS email,
	                
					(SELECT TOP 1 A.password 
					 FROM Trocaire_Extra.dbo.ADADInfo A
					 WHERE A.StudentID = ST.StudentID AND A.AType IN (@BatchParam) 
													  AND A.Term IN (@TermParam)) AS password,
					REPLACE(ST.FirstName, '''', '') AS firstname,
					REPLACE(ST.LastName, '''', '') AS lastname
	INTO dbo.SA_tmpADFinalMoodleUsers    				
	FROM Trocaire_Extra.dbo.ADADInfo AI
	LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
		ON (AI.StudentUID = ST.StudentUID)
	LEFT OUTER JOIN CAMS_Enterprise.dbo.Student_Address STA1
		   ON (AI.StudentUID = STA1.StudentID)
	LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
		   ON (STA1.AddressID = ADR1.AddressID)
	LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL2
		   ON (ADR1.AddressTypeID = GL2.UniqueId)
	LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal SPT
		   ON (SPT.StudentUID = ST.StudentUID)
	WHERE (AI.AType IN (@BatchParam) AND AI.Term IN (@TermParam)) /*Curriculum from Glossary Table */ 
		  AND GL2.DisplayText = 'Local' AND ADR1.ActiveFlag = 'Yes'
		  AND NOT ST.StudentID = 'C0000032870' AND ADR1.Email1 LIKE '%@trocaire.edu'

	
END

GO


