DROP TABLE #tmpA
DROP TABLE #DRP
DROP TABLE #STD
drop table #tmpfa17

    -- Insert statements for procedure here
	    -- Insert statements for procedure here

select 'autofill' as action, a.courseid, a.Userid, a.roletype as role, a.status
into #tmpA
from
(
SELECT '"1"' AS IDType,
       'student' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section AS CourseID,
       ST.StudentID AS UserID, '0' as Status
FROM CAMS_Enterprise.dbo.SRAcademic SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
    ON (SR.StudentUID = ST.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = SR.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal SPT
       ON (SPT.StudentUID = SR.StudentUID)
WHERE TC.TextTerm = 'FA-17' AND SR.CategoryID = 1099  /*Added for early Fall classes*/ 
      /*AND SR.Department + SR.CourseID IN ('NU124', 'NU216', 'NU217', 'NU220')*/
      /* Add Ends here*/   
      AND NOT ST.StudentID = 'C0000032870'  AND NOT SR.GRADE = 'W' AND EXISTS
      (SELECT * FROM CAMS_Enterprise.dbo.CAMS_StudentAddressList_View SAV 
                WHERE SAV.StudentID = ST.StudentID AND SAV.AddressType = 'local' AND SAV.Email1 LIKE '%@trocaire.edu') 

UNION

SELECT '"1"' AS IDType,
       'editingteacher' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section  AS CourseID,
       CAST(FP.FacultyID AS CHAR(8)) AS UserID, '0' as status
FROM CAMS_Enterprise.dbo.SROffer SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = SR.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.SROfferSchedule SROS
      ON (SR.SROfferID = SROS.SROfferID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.SROfferSchedule_Faculty SROSF
      ON (SROSF.SROfferScheduleID = SROS.SROfferScheduleID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.FacultyPortal FP
      ON (FP.FacultyID = SROSF.FacultyID)
WHERE TC.TextTerm ='FA-17' /*Added for early Fall classes*/ 
     /* AND SR.Department + SR.CourseID IN ('NU124', 'NU216', 'NU217', 'NU220')*/
      /* Add Ends here*/   
) A
--ORDER BY a.CourseID, a.RoleType



    -- Insert statements for procedure here
SELECT '"1"' AS IDType,
       'student' AS RoleType,
       DB.Department + DB.CourseID + DB.CourseType + DB.Section  AS CourseID,
       ST.StudentID AS UserID, '1' as status
INTO #DRP              
FROM CAMS_Enterprise.dbo.DropBag DB
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
    ON (DB.StudentUID = ST.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = DB.TermCalendarID)
WHERE TC.TextTerm = 'FA-17' AND DB.CategoryID = 1099
      AND NOT ST.LastName = 'Testperson' 
--ORDER BY CourseID, RoleType

SELECT '"1"' AS IDType,
       'student' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section AS CourseID,
       ST1.StudentID AS UserID, '1' as status
INTO #STD       
FROM CAMS_Enterprise.dbo.SRAcademic SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
    ON (SR.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
      ON (TC1.TermCalendarID = SR.TermCalendarID)
WHERE TC1.TextTerm = 'FA-17' AND SR.CategoryID = 1099
      AND NOT ST1.LastName = 'Testperson' And Not SR.Grade = 'W'
--ORDER BY CourseID, RoleType

select case g.status when '1' THEN 'delete' else 'update' end as action, 
g.CourseID, g.UserID,g.role,Status
into #tmpfa17
  from
 ( 
select * from #tmpA
union
select 'autofill' as action, b.courseid, b.Userid, b.roletype as role, b.status
from
(
SELECT D1.*
FROM #DRP D1
WHERE NOT EXISTS (SELECT S1.* FROM #STD S1 WHERE S1.CourseID = D1.CourseID AND S1.UserID = D1.UserID)
--ORDER BY CourseID, RoleType
) B
) G


--ORDER BY a.CourseID, a.RoleType




-- ___________________________________________

DROP TABLE #tmpA1
DROP TABLE #DRP1
DROP TABLE #STD1
drop table #tmpsp17



    -- Insert statements for procedure here
	    -- Insert statements for procedure here

select 'autofill' as action, a.courseid, a.Userid, a.roletype as role, a.status
into #tmpA1
from
(
SELECT '"1"' AS IDType,
       'student' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section AS CourseID,
       ST.StudentID AS UserID, '0' as Status
FROM CAMS_Enterprise.dbo.SRAcademic SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
    ON (SR.StudentUID = ST.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = SR.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentPortal SPT
       ON (SPT.StudentUID = SR.StudentUID)
WHERE TC.TextTerm = 'sp-17' AND SR.CategoryID = 1099  /*Added for early Fall classes*/ 
      /*AND SR.Department + SR.CourseID IN ('NU124', 'NU216', 'NU217', 'NU220')*/
      /* Add Ends here*/   
      AND NOT ST.StudentID = 'C0000032870'  AND NOT SR.GRADE = 'W' AND EXISTS
      (SELECT * FROM CAMS_Enterprise.dbo.CAMS_StudentAddressList_View SAV 
                WHERE SAV.StudentID = ST.StudentID AND SAV.AddressType = 'local' AND SAV.Email1 LIKE '%@trocaire.edu') 

UNION

SELECT '"1"' AS IDType,
       'editingteacher' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section AS CourseID,
       CAST(FP.FacultyID AS CHAR(8)) AS UserID, '0' as status
FROM CAMS_Enterprise.dbo.SROffer SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = SR.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.SROfferSchedule SROS
      ON (SR.SROfferID = SROS.SROfferID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.SROfferSchedule_Faculty SROSF
      ON (SROSF.SROfferScheduleID = SROS.SROfferScheduleID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.FacultyPortal FP
      ON (FP.FacultyID = SROSF.FacultyID)
WHERE TC.TextTerm ='sp-17' /*Added for early Fall classes*/ 
     /* AND SR.Department + SR.CourseID IN ('NU124', 'NU216', 'NU217', 'NU220')*/
      /* Add Ends here*/   
) A
--ORDER BY a.CourseID, a.RoleType



    -- Insert statements for procedure here
SELECT '"1"' AS IDType,
       'student' AS RoleType,
       DB.Department + DB.CourseID + DB.CourseType + DB.Section  AS CourseID,
       ST.StudentID AS UserID, '1' as status
INTO #DRP1             
FROM CAMS_Enterprise.dbo.DropBag DB
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
    ON (DB.StudentUID = ST.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
      ON (TC.TermCalendarID = DB.TermCalendarID)
WHERE TC.TextTerm = 'sp-17' AND DB.CategoryID = 1099
      AND NOT ST.LastName = 'Testperson' 
--ORDER BY CourseID, RoleType

SELECT '"1"' AS IDType,
       'student' AS RoleType,
       SR.Department + SR.CourseID + SR.CourseType + SR.Section  AS CourseID,
       ST1.StudentID AS UserID, '1' as status
INTO #STD1    
FROM CAMS_Enterprise.dbo.SRAcademic SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
    ON (SR.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
      ON (TC1.TermCalendarID = SR.TermCalendarID)
WHERE TC1.TextTerm = 'sp-17' AND SR.CategoryID = 1099
      AND NOT ST1.LastName = 'Testperson' And Not SR.Grade = 'W'
--ORDER BY CourseID, RoleType

select case g.status when '1' THEN 'delete' else 'update' end as action, 
g.CourseID, g.UserID,g.role,Status
into #tmpsp17
  from
 ( 
select * from #tmpA1
union
select 'autofill' as action, b.courseid, b.Userid, b.roletype as role, b.status
from
(
SELECT D1.*
FROM #DRP1 D1
WHERE NOT EXISTS (SELECT S1.* FROM #STD1 S1 WHERE S1.CourseID = D1.CourseID AND S1.UserID = D1.UserID)
--ORDER BY CourseID, RoleType
) B
) G



--ORDER BY a.CourseID, a.RoleType

select courseid+'-'+userid as param1,*
into #fa17
from #tmpfa17
where role='editingteacher'

select (courseid+'-'+userid)  as param2,*
into #sp17
from #tmpsp17
where role='editingteacher'


select f.*  from #fa17 f
inner join 
#sp17 g on f.CourseID=g.CourseID and f.UserID=g.UserID


DROP TABLE #tmpA
DROP TABLE #DRP
DROP TABLE #STD
drop table #tmpfa17

DROP TABLE #tmpA1
DROP TABLE #DRP1
DROP TABLE #STD1
drop table #tmpsp17
drop table #sp17
drop table #fa17






