USE [CAMS_Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[Generate_Accepted_Students]    Script Date: 04/17/2017 16:51:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Generate_Accepted_Students]
    @Tm varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT DISTINCT 
               dbo.CAMS_Student_View.StudentID, dbo.CAMS_Student_View.LastName, dbo.CAMS_Student_View.FirstName, dbo.CAMS_StudentAddressList_View.Address1, 
               dbo.CAMS_StudentAddressList_View.AddressType, dbo.CAMS_StudentAddressList_View.City, dbo.CAMS_StudentAddressList_View.State, 
               dbo.CAMS_StudentAddressList_View.ZipCode, dbo.CAMS_StudentProgram_View.MajorDegree, dbo.CAMS_Student_View.ExpectedTerm, 
               dbo.CAMS_Student_View.AdmitDate, dbo.CAMS_StudentAddressList_View.Email1, dbo.CAMS_StudentAddressList_View.ActiveFlag,
               dbo.CAMS_Student_View.ProspectStatus as ApplicantStatus, dbo.CAMS_Student_View.Type
               
FROM  dbo.CAMS_Student_View INNER JOIN
               dbo.CAMS_StudentAddressList_View ON dbo.CAMS_Student_View.StudentUID = dbo.CAMS_StudentAddressList_View.StudentUID LEFT OUTER JOIN
               dbo.CAMS_StudentProgram_View ON dbo.CAMS_Student_View.StudentUID = dbo.CAMS_StudentProgram_View.StudentUID LEFT OUTER JOIN
               dbo.StudentPortal ON dbo.CAMS_Student_View.StudentUID = dbo.StudentPortal.StudentUID
WHERE (dbo.CAMS_StudentAddressList_View.AddressType = 'Local') AND (dbo.CAMS_Student_View.AdmitDate <> '') AND 
               (dbo.CAMS_Student_View.ProspectStatusID IN (1, 3))
                AND (dbo.CAMS_Student_View.ExpectedTerm = @Tm) 
               AND dbo.CAMS_StudentAddressList_View.ActiveFlag='Yes'
               AND dbo.CAMS_StudentProgram_View.TermCalendarID= dbo.gettermID(@Tm)

END
