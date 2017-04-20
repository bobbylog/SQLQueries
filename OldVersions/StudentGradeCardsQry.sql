SELECT  
 "tmpRptGradeCards"."StudentUID",
 "tmpRptGradeCards"."TextTerm",
 "tmpRptGradeCards"."LastName", "tmpRptGradeCards"."FirstName", 
 "tmpRptGradeCards"."MiddleName",
 "tmpRptGradeCards"."Department", "tmpRptGradeCards"."CourseID", 
 "tmpRptGradeCards"."Section", 

"tmpRptGradeCards"."CourseName",
  "tmpRptGradeCards"."Grade"
  
 FROM   "CAMS_Enterprise"."dbo"."tmpRptGradeCards" "tmpRptGradeCards"
WHERe
"tmpRptGradeCards"."Department"='NU'
order by   "tmpRptGradeCards"."StudentUID", "tmpRptGradeCards"."TextTerm"


