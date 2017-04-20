Select Distinct A.StudentUID, A.GPAGroupID 
Into #GradeSummaryBYOR 
From SRAcademic A  Inner Join StudentStatus as C 
ON A.StudentUID = C.StudentUID AND A.TermCalendarID = C.TermCalendarID  
inner Join StudentProgram as D ON D.studentStatusID = C.StudentStatusID 
Where (A.TermCalendarID = 612)  AND (D.MajorProgramID = 143)

--Select Distinct A.StudentUID, A.GPAGroupID Into #GradeSummaryBYOR From SRAcademic A Where (A.TermCalendarID = 612) 
Exec CAMS_PrintGradeSummaryTonyRep 612, '#GradeSummaryBYOR', 143 ,'', 3.5,4, 0.00001, 9.9999
DROP TABLE #GradeSummaryBYOR


--Select Distinct * From SRAcademic A Where (A.TermCalendarID = 612) 