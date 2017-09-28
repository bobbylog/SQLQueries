--SELECT DateAccepted, Term, StudentID, LastName, FirstName, MiddleInitial,'include' as itemStatus, DegreeProgram
----into #admittable
--FROM     dbo.CTM_AcceptedStudentsBatch
--union
--select  admitdate as DateAccepted, 'SP-18' as Term, StudentID, Lastname, Firstname, MiddleName as MiddleInitial, 'include' as itemStatus, isnull(dbo.getCurrentMajorFromUIDByTerm(studentuid, dbo.getTermID('sp-18')),dbo.getMajorName(ProgramsID)) as DegreeProgram  from CAMS_Student_View 
--where cast(admitdate as date)='09/25/2017'


--SELECT BatchID, DateCollected, DateAccepted, Term, StudentID, LastName, FirstName, MiddleInitial, UserID, NPassword, Password, AType, Address, CSZ, itemStatus, 
--                  DegreeProgram
--FROM     dbo.CTM_AcceptedStudentsBatch

--select * from #admittable at
--inner join  dbo.CTM_AcceptedStudentsBatch
--drop table #admittable

--drop table #admittable

select  'New' as BatchID, GETDATE() as DateCollected, Admitdate as DateAccepted, 'SP-18' as Term, StudentID, LastName, FirstName,  MiddleInitial, '' as UserID, '' as NPassword, '' as Password, 'New' as AType, dbo.getStudentMailingAddressWOptions(StudentUID,1) as Address, dbo.getStudentMailingAddressWOptions(StudentUID,2) as CSZ, 'include' as itemStatus,  
isnull(dbo.getCurrentMajorFromUIDByTerm(studentuid, dbo.getTermID('sp-18')),dbo.getMajorName(ProgramsID)) as DegreeProgram 
into #admittable
from Student
where cast(admitdate as date)='09/25/2017' 
and ExpectedTermID=617
and studentid not in
( SELECT StudentID FROM dbo.CTM_AcceptedStudentsBatch where Term='SP-18' )

declare @nc int
set @nc=(select count(studentid) from #admittable)

select * from #admittable

if @nc >0
insert into 
dbo.CTM_AcceptedStudentsBatch (BatchID, DateCollected, DateAccepted, Term, StudentID, LastName, FirstName, MiddleInitial, UserID, NPassword, Password, AType, Address, CSZ, itemStatus, 
                  DegreeProgram)
select BatchID, DateCollected, DateAccepted, Term, StudentID, LastName, FirstName, MiddleInitial, UserID, NPassword, Password, AType, Address, CSZ, itemStatus, 
                 DegreeProgram
 from #admittable



drop table #admittable