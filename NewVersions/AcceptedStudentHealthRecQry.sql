select S.StudentID, S.StudentUID, S.LastName, S.FirstName, s.MiddleInitial, S.AdmitDate as DateAdmitted, 
S.DateAccepted as DateApplied, S.birthdate, dbo.getStudentEmailAddress(S.StudentUID) as Email,dbo.getStudentPhoneNo(S.StudentUID) as Phone, dbo.getTermText(S.ExpectedTermID) as IntendedTerm, dbo.getMajorName(S.ProgramsID) as IntendedMajor, SH.Measles, SH.Measles2, SH.Mumps, SH.Rubella, '' as CPR, '' as FluShot, '' as HIPPATRNG , SH.Explanations 
,sh.*
from Student S
left outer  join StudentHealth SH
on s.StudentUID=sh.StudentUID
where 
--s.ExpectedTermID=615
s.AdmitDate <>'' and 
S.ExpectedTermID=616
--MONTH(S.admitdate)=3
--and DAY(S.admitDate) between 27 and 29
--and YEAR(S.admitdate)=2017

--select * from StudentHealth