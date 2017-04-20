/********************************************************************/
/*  This is the one to use.  Last used 1/5/2013 to delete students  */
/*  with last term equal SU-11, FA-11, FA-BSN-11.                   */
/********************************************************************/

SELECT AC.ACCOUNT, AC.CUSTOM, AC.FNAME, AC.LNAME, AC.P_TITLE, ST.StudentUID
INTO #RW
FROM OneCard.onecard.ACCOUNTS AC
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
WHERE DisplayTerm IN ('SU-11', 'FA-11', 'FA-BSN-11')
ORDER BY LastTerm, LNAME, FNAME


/*SELECT * FROM #DELETE
ORDER BY LastTerm, LNAME, FNAME
*/

SELECT *
FROM OneCard.onecard.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)


/*SELECT *
INTO OneCard.dbo.DELETES010713
FROM OneCard.onecard.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)
*/
/*
DELETE FROM OneCard.onecard.ACCOUNTS
WHERE CUSTOM IN (SELECT CUSTOM FROM #Delete)
*/
      
DROP TABLE #RW 
DROP TABLE #MT
DROP TABLE #Final 
DROP TABLE #Delete    











