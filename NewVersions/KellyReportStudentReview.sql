select top 100 '' as Rank, studentuid, LastName,FirstName, '' as Admit, '' as Reg, dbo.getStudentMailingAddress(studentuid) as Address,'' as CSZ, 
dbo.getStudentEmailAddress(StudentUID) as Email,
dbo.getStudentTrocGPA(studentuid) as GPA, 
'' as Pts, 
'' as AP_PI, 
'' as Pts, 
( select Score from CAMS_Testscore
where CAMS_TestID=
(select top 1 CAMS_TestID from CAMS_Test
where OwnerID=studentuid
and CAMS_TestRefID=13)
 --23514
--and CAMS_TestRefID=13
and CAMS_TestScoreRefID=52)
 as TEAS, 
'' as Pts, 
'' as TC, 
'' as XferForm,
'' as Admin, 
'' as LetterSent, 
'' as DAY_Comments
from student
where ExpectedTermID=616