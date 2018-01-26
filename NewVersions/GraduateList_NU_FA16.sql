-- select TextTerm from Termcalendar Where (TermcalendarID = 612)
drop table #tmpTable
drop table #GradeSummaryBYOR


-- Nursing Grade Fa-16
--Select Distinct A.StudentUID, A.GPAGroupID Into #GradeSummaryBYOR  From SRAcademic A  
--Inner Join StudentStatus as C ON A.StudentUID = C.StudentUID AND A.TermCalendarID = C.TermCalendarID  
--inner Join StudentProgram as D ON D.studentStatusID = C.StudentStatusID  
--Inner Join StudentDegree as H ON A.StudentUID = H.StudentUID 
--Where (A.TermCalendarID = 612)  AND (D.MajorProgramID = 109) AND (H.ExpectedTermID = 612)

--Nursing Certificate Graduate


Declare @cterm int
set @cterm=616


Select Distinct A.StudentUID, A.GPAGroupID Into #GradeSummaryBYOR From SRAcademic A  
Inner Join StudentStatus as C ON A.StudentUID = C.StudentUID AND A.TermCalendarID = C.TermCalendarID  
inner Join StudentProgram as D ON D.studentStatusID = C.StudentStatusID  
Inner Join StudentDegree as H ON A.StudentUID = H.StudentUID 
Where (A.TermCalendarID = 616)  AND (D.MajorProgramID = 109) AND (H.ExpectedTermID = 616)

create table #tmpTable
(
 StudentID varchar(25),
 StudentSSN varchar(25),
 Birthdate varchar(25),
 LastName varchar(150),
 FirstName varchar(150),
 MiddleInitial varchar(150),
 Major varchar(150),
 Term varchar(25),
 LPN varchar(25)
 )

 insert into #tmpTable
 Exec CAMS_PrintGradReports 616, '#GradeSummaryBYOR', '', 109

--select * from CAMS_StudentDegree_View
--where dbo.getStudentIDFromUID(Studentuid)='A0000018599'

--select studentuid from CAMS_StudentDegree_View 
--	where Studentuid=dbo.getstudentuidfromid('A0000018599')

--	--and DegreeEarned='Yes' 
--	and Degree like 'Certificate%'
--	-- GraduationDate is not null
--	and ExpectedTermID=602
select *, dbo.getStudentMailingAddress(dbo.getStudentUIDFromID(StudentID)) as MailingAddress , dbo.getStudentEmailAddressFromID(StudentID) as Email1, dbo.getStudentPhoneNo(dbo.getStudentUIDFromID(StudentID)) as PhoneNo  from #tmpTable

drop table #tmpTable
drop table #GradeSummaryBYOR