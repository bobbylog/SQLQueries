USE [CAMS_Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[TCC_Accepted_Student_Health_Check]    Script Date: 04/06/2017 14:36:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[InsertStudentScoresFromAccOrg] 
 @Ouid varchar(25), 
 @TDate varchar(25), 
 @TName varchar(50), 
 @TScore1 decimal(10,5) , 
 @TPercent decimal (10,5),
 @AuthStatus int

 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	declare @nc bigint
	
	BEGIN TRANSACTION;

	BEGIN TRY

		if (@AuthStatus=1)
			begin
			
				 insert into CAMS_Test1 (CAMS_TestRefID, OwnerID, TestDate, SourceID, Stateid, TypeId, UsedForPlacement, InsertUserID, Inserttime, lock)
							VALUES (12, @Ouid, @TDate, 0, 0, 0,0, 'ONLINEACC',GETDATE(),0)     
			     
				 select top 1 @nc=CAMS_testID from CAMS_Test1 order by CAMS_testID desc
			     
				 insert into CAMS_TestScore1 (CAMS_TestScoreRefID, CAMS_TestID, Score, Percentile, ScoreStatusID, UsedForPlacement, InsertUSerID)
							 VALUES (dbo.getScoreNameID(@TName), @nc, @TScore1, 0.00, 0, 0, 'ONLINEACC')
					
			end
				
	END TRY
	BEGIN CATCH
		SELECT 
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;

	 IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	 END CATCH;	 
				 
	 IF @@TRANCOUNT > 0
	   COMMIT TRANSACTION;
 
     
     	            
			-- get testid
			-- insert in testscore camstestscoreref, testid, score, percentile (0), scorestatus (0), userforplace (0), insertuserid (online),

	

END
