-- select TextTerm from Termcalendar Where (TermcalendarID = 612)

-- Nursing Grade Fa-16
--Select Distinct A.StudentUID, A.GPAGroupID Into #GradeSummaryBYOR  From SRAcademic A  
--Inner Join StudentStatus as C ON A.StudentUID = C.StudentUID AND A.TermCalendarID = C.TermCalendarID  
--inner Join StudentProgram as D ON D.studentStatusID = C.StudentStatusID  
--Inner Join StudentDegree as H ON A.StudentUID = H.StudentUID 
--Where (A.TermCalendarID = 612)  AND (D.MajorProgramID = 109) AND (H.ExpectedTermID = 612)

-- Practical Nursing Certificate Graduate
Select Distinct A.StudentUID, A.GPAGroupID Into #GradeSummaryBYOR From SRAcademic A  
Inner Join StudentStatus as C ON A.StudentUID = C.StudentUID AND A.TermCalendarID = C.TermCalendarID  
inner Join StudentProgram as D ON D.studentStatusID = C.StudentStatusID  
Inner Join StudentDegree as H ON A.StudentUID = H.StudentUID 
Where (A.TermCalendarID = 602)  AND (D.MajorProgramID = 143) AND (H.ExpectedTermID = 602)

Exec CAMS_PrintGradReports 602, '#GradeSummaryBYOR', '', 143

select * from CAMS_StudentDegree_View
where dbo.getStudentIDFromUID(Studentuid)='A0000018599'

select studentuid from CAMS_StudentDegree_View 
	where Studentuid=dbo.getstudentuidfromid('A0000018599')

	--and DegreeEarned='Yes' 
	and Degree like 'Certificate%'
	-- GraduationDate is not null
	and ExpectedTermID=602


drop table #GradeSummaryBYOR