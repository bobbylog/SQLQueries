/********************************************************************/
/*  This is the one to use.  Last used 4/26/17 to delete students  */
/*  with last term equalSU-12', 'FA-12', 'FA-BSN-12', 'SP-12','SP-13',*/
/*'SU-13','FA-13','SP-14','SU-14','FA-14', 'FA-BSN-13', 'FA-BSN-14', 'SP-15'*/
/********************************************************************/

SELECT AC.ACCOUNT, AC.CUSTOM, AC.FNAME, AC.LNAME, AC.P_TITLE, ST.StudentUID
INTO #RW
FROM OneCard.onecard2.ACCOUNTS AC
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
      ON (AC.CUSTOM COLLATE SQL_Latin1_General_CP1_CI_AI = ST.StudentID)
      
SELECT SR1.StudentUID, MAX(TC1.Term) AS MaxTerm
INTO #MT
FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
      ON (SR1.TermCalendarID = TC1.TermCalendarID)
GROUP BY SR1.StudentUID    
ORDER BY SR1.StudentUID     
      
SELECT R1.*,
       case
           when exists (SELECT M.MaxTerm FROM #MT M WHERE M.StudentUID = R1.StudentUID) then
                       (SELECT M.MaxTerm FROM #MT M WHERE M.StudentUID = R1.StudentUID)
           else 'NoReg'
       end AS LastTerm,
       case
           when exists (SELECT M.MaxTerm FROM #MT M WHERE M.StudentUID = R1.StudentUID) then
                       (SELECT TC4.TextTerm 
                        FROM #MT M
                        LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC4
                              ON (TC4.Term = M.MaxTerm) 
                        WHERE M.StudentUID = R1.StudentUID)
           else 'NoReg'
       end AS DisplayTerm
INTO #Final                          
FROM #RW R1 

SELECT *
INTO #Delete
FROM #Final   
WHERE DisplayTerm IN ('SU-12', 'FA-12', 'FA-BSN-12', 'SP-12','SP-13','SU-13','FA-13','SP-14','SU-14','FA-14', 'FA-BSN-13', 'FA-BSN-14', 'SP-15')
ORDER BY LastTerm, LNAME, FNAME


/*SELECT * FROM #DELETE
ORDER BY LastTerm, LNAME, FNAME
*/

/*
SELECT *
FROM OneCard.onecard2.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)
*/

/*
SELECT *
INTO OneCard.dbo.DELETES042617
FROM OneCard.onecard2.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)
*/

/*
DELETE FROM OneCard.onecard2.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)
*/
      
DROP TABLE #RW 
DROP TABLE #MT
DROP TABLE #Final 
DROP TABLE #Delete    











