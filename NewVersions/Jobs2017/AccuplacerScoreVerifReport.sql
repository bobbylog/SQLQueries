SELECT dbo.CAMS_Test.CAMS_TestID, dbo.CAMS_Test.CAMS_TestRefID, dbo.CAMS_Test.OwnerID,dbo.getStudentFullName(dbo.getStudentIDFromUID(OwnerID)) as sname, dbo.CAMS_Test.TestDate, dbo.CAMS_Test.Note, 
               dbo.CAMS_Test.InsertUserID, dbo.CAMS_TestScore.Score, dbo.CAMS_TestScore.CAMS_TestScoreID, dbo.CAMS_TestScore.CAMS_TestScoreRefID
               ,[dbo].[getVerifiedStuBatchScore] (
							Ownerid,
							Testdate,
							Score,
							CAMS_TestScoreRefID) As ScoreInBatch
FROM  dbo.CAMS_Test INNER JOIN
               dbo.CAMS_TestScore ON dbo.CAMS_Test.CAMS_TestID = dbo.CAMS_TestScore.CAMS_TestID
WHERE (dbo.CAMS_Test.TestDate = CONVERT(DATETIME, '2017-05-23 00:00:00', 102)) AND (dbo.CAMS_Test.CAMS_TestRefID = 12)