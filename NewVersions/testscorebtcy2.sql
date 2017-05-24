select * from CAMS_testscore1
select  CAMS_Testid, CAMS_TestRefID, OwnerID,TestDate,Note, dbo.getStudentFullName (dbo.getstudentidfromuid(Ownerid))as fname from CAMS_test1