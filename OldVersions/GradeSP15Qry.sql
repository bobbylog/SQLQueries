
select distinct Tmptb.* from
(
SELECT  
 "tmpRptGradeCards"."StudentUID",
 "tmpRptGradeCards"."LastName", "tmpRptGradeCards"."FirstName", 
 "tmpRptGradeCards"."MiddleName",
 "tmpRptGradeCards"."Department", "tmpRptGradeCards"."CourseID", 
 "tmpRptGradeCards"."Section", 
"tmpRptGradeCards"."TextTerm",
"tmpRptGradeCards"."CourseName",
  "tmpRptGradeCards"."Grade"
  
 FROM   "CAMS_Enterprise"."dbo"."tmpRptGradeCards" "tmpRptGradeCards"
WHERe
"tmpRptGradeCards"."Department"='NU'
) Tmptb