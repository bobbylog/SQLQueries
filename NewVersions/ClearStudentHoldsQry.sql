select *, dbo.getstudentIDfromUID(StudentUID), StudentHoldsID, StopOnLineRegistration from StudentHolds
where HoldStatusID =807
AND HoldCategoryID =47

--select * from CAMS_StudentHolds_view

--update StudentHolds set StopOnLineRegistration=0 
--where HoldStatusID =807
--AND HoldCategoryID =47
