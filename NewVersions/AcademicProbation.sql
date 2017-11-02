DECLARE  @UTerm varchar(10)
DECLARE @USort varchar(10)
DECLARE @ULDate varchar(40)
DECLARE @UNSem varchar(40)
DECLARE @URType varchar(40)


set @UTerm='sp-17'
set @USort='1'
set @ULDate='10/26/2017'
set @UNSem='fa-17'
set @URType='preport'


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
Declare @BackTerm as Varchar(12)
Declare @BackTermY as Varchar(12)

set @BackTermY = CAST(100 + CAST(SUBSTRING(@UTerm, LEN(@UTerm) - 1, 2) AS INT) -10 AS Varchar(12))
set @BackTerm = SUBSTRING(@UTerm, 1, 3) + SUBSTRING(@BackTermY, LEN(@BackTermY) - 1, 2)


/* Find students registered for inputted term */
SELECT TC.TextTerm, TC.Term, TC.TermCalendarID, ST.StudentID, ST.StudentUID, 
       ST.LastName, ST.FirstName, ST.MiddleInitial, SUM(SR.Credits) AS TCRED
INTO #allreg 
FROM CAMS_Enterprise.dbo.SRAcademic SR
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST
    ON (SR.StudentUID = ST.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC
    ON (TC.TermCalendarID = SR.TermCalendarID)
WHERE TC.TextTerm = @UTerm AND SR.CategoryID = 1099 AND SR.RegistrationStatus = 'Official' 
      AND NOT ST.LastName = 'Testperson'
      AND NOT SR.Grade = 'AU' AND NOT SR.Grade = ''
GROUP BY TC.TextTerm, TC.Term, TC.TermCalendarID, ST.StudentID, ST.StudentUID,
         ST.LastName, ST.FirstName, ST.MiddleInitial
ORDER BY ST.LastName, ST.FirstName, ST.MiddleInitial

/* Eliminate all Non-Matrics and those with 0 credits plus*/
/* add Program and Advisor Info */
SELECT AR.TextTerm, AR.Term, AR.TermCalendarID, AR.StudentID, AR.StudentUID, 
       AR.LastName, AR.FirstName, AR.MiddleInitial, AR.TCRED, SPV6.MajorDegree AS Program, SPV6.Advisor
INTO #allregplus       
FROM #allreg AR
LEFT OUTER JOIN CAMS_Enterprise.dbo.CAMS_StudentProgram_View SPV6
       ON (SPV6.StudentUID = AR.StudentUID AND SPV6.TermCalendarID = AR.TermCalendarID AND SPV6.SequenceNo = 0)
WHERE NOT (SPV6.MajorDegree = 'Non-Matriculant' OR AR.TCRED = 0)

/* Find Term Hours and GPA for Targeted term students over the last ten years */
SELECT SGV6.StudentUID, SGV6.TermCalendarID, TC6.Term, TC6.TextTerm, SGV6.GPAHours, SGV6.TermGPA
INTO #TGPA
FROM CAMS_Enterprise.dbo.CAMS_StudentTermGPA_View SGV6
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC6
      ON (TC6.TermCalendarID = SGV6.TermCalendarID)
WHERE SGV6.StudentUID IN (SELECT StudentUID FROM #allregplus) AND 
      TC6.Term > (SELECT Term FROM TermCalendar WHERE TextTerm =  @BackTerm) AND
      TC6.Term <= (SELECT Term FROM TermCalendar WHERE TextTerm =  @UTerm) /*AND
      SGV6.TermGPA < 2.0000 AND
      SGV6.GPAHours > 0
*/
      
/* Find all registered terms for targeted students over the last 10 years */
SELECT TC4.TextTerm, TC4.Term, TC4.TermCalendarID, ST4.StudentID, ST4.StudentUID, 
       SUM(SR4.Credits) AS TCRED
INTO #allreg10 
FROM CAMS_Enterprise.dbo.SRAcademic SR4
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST4
    ON (SR4.StudentUID = ST4.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC4
    ON (TC4.TermCalendarID = SR4.TermCalendarID)
WHERE ST4.StudentUID IN (SELECT StudentUID FROM #allregplus) AND 
      TC4.Term > (SELECT Term FROM TermCalendar WHERE TextTerm =  @BackTerm) AND
      TC4.Term <= (SELECT Term FROM TermCalendar WHERE TextTerm =  @UTerm) 
      AND SR4.CategoryID = 1099 AND SR4.RegistrationStatus = 'Official'
      AND NOT SR4.Grade = 'AU' AND NOT SR4.Grade = ''
GROUP BY TC4.TextTerm, TC4.Term, TC4.TermCalendarID, ST4.StudentID, ST4.StudentUID

/* Eliminate all Non-Matrics and those with 0 credits from 10 year data*/
SELECT AR5.TextTerm, AR5.Term, AR5.TermCalendarID, AR5.StudentID, AR5.StudentUID, 
       AR5.TCRED, SPV5.MajorDegree AS Program, SPV5.Advisor
INTO #allregplus10       
FROM #allreg10 AR5
LEFT OUTER JOIN CAMS_Enterprise.dbo.CAMS_StudentProgram_View SPV5
       ON (SPV5.StudentUID = AR5.StudentUID AND SPV5.TermCalendarID = AR5.TermCalendarID AND SPV5.SequenceNo = 0)
WHERE NOT (SPV5.MajorDegree = 'Non-Matriculant' OR AR5.TCRED = 0)

/* Find Total Credits over last 10 years */
SELECT StudentUID, SUM(TCRED) AS CTCRED
INTO #STC
FROM #allregplus10 
GROUP BY StudentUID
ORDER BY StudentUID




/* Find max term minus summers from 10 year data */
SELECT StudentUID, StudentID, MAX(Term) AS LastTerm
INTO #SLT
FROM #allregplus10
WHERE NOT TextTerm = @UTerm AND NOT (TextTerm LIKE 'SU%' AND LEN(TextTerm) = 5) 
GROUP BY StudentUID, StudentID
      
SELECT AR1.TextTerm, AR1.Term, AR1.TermCalendarID, AR1.StudentID, AR1.StudentUID, 
       AR1.LastName, AR1.FirstName, AR1.MiddleInitial, AR1.TCRED, AR1.Program, AR1.Advisor,
       ISNULL((SELECT A.TermGPA 
        FROM #TGPA A 
        WHERE A.StudentUID = AR1.StudentUID AND A.TermCalendarID = AR1.TermCalendarID), 8888) AS TermGPA,
       ISNULL((SELECT A.GPAHours 
        FROM #TGPA A 
        WHERE A.StudentUID = AR1.StudentUID AND A.TermCalendarID = AR1.TermCalendarID), 8888) AS TermGAPHours,
       ISNULL((SELECT COUNT( A1.StudentUID) 
        FROM #TGPA A1 
        WHERE A1.StudentUID = AR1.StudentUID AND A1.TermGPA < 2.0000 AND A1.GPAHours > 0
        GROUP BY A1.StudentUID), '') AS TTerm,
       ISNULL((SELECT COUNT( A2.StudentUID) 
        FROM #TGPA A2 
        WHERE A2.StudentUID = AR1.StudentUID AND A2.TermGPA < 2.0000 AND A2.GPAHours > 0 AND NOT A2.TextTerm LIKE 'SU%'
        GROUP BY A2.StudentUID), '') AS TTermNoSu,
        ISNULL(CASE
                  when NOT (SELECT S1.LastTerm from #SLT S1 WHERE S1.StudentUID = AR1.StudentUID) IS NULL then
                           (SELECT S1.LastTerm from #SLT S1 WHERE S1.StudentUID = AR1.StudentUID) else '' 
               end, '') AS LTerm,
       ISNULL((SELECT STC8.CTCRED 
        FROM #STC STC8 
        WHERE STC8.StudentUID = AR1.StudentUID), 0) AS CTCRED,
        ISNULL((SELECT SCG.CumGPA
                FROM CAMS_Enterprise.dbo.CAMS_StudentCumulativeGPA_View SCG
                WHERE SCG.StudentUID = AR1.StudentUID AND 
                      SCG.TermCalendarID = (SELECT TermCalendarID FROM CAMS_Enterprise.dbo.TermCalendar  WHERE TermCalendar.TextTerm = @UTerm)), 0) AS CGPA             
INTO #allregfinal                
FROM #allregplus AR1





SELECT AF1.TextTerm, AF1.Term, AF1.TermCalendarID, AF1.StudentID, AF1.StudentUID, 
       AF1.LastName, AF1.FirstName, AF1.MiddleInitial, AF1.CGPA, AF1.CTCRED, AF1.TCRED, AF1.Program, AF1.Advisor,
       TermGPA, TermGAPHours, TTerm, TTermNoSu,
       AF1.LTerm,
       CASE
           WHEN NOT AF1.LTerm = '' THEN 
                  (SELECT TC5.TextTerm FROM CAMS_Enterprise.dbo.TermCalendar TC5 WHERE TC5.Term = AF1.LTerm)
           ELSE ''
       END AS LastTerm,
       CASE
           WHEN NOT AF1.LTerm = '' THEN 
                  (SELECT TC6.TermCalendarID FROM CAMS_Enterprise.dbo.TermCalendar TC6 WHERE TC6.Term = AF1.LTerm)
           ELSE ''
       END AS LastTermID,       
       ISNULL((SELECT A8.TermGPA 
        FROM #TGPA A8 
        WHERE A8.StudentUID = AF1.StudentUID AND A8.Term = AF1.LTerm), 8888) AS LTermGPA,
       ISNULL((SELECT A8.GPAHours 
        FROM #TGPA A8 
        WHERE A8.StudentUID = AF1.StudentUID AND A8.Term = AF1.LTerm), 8888) AS LTermGAPHours,
       ISNULL((SELECT A10.TCRED FROM #allreg10 A10 
       WHERE A10.StudentUID = AF1.StudentUID AND A10.Term = AF1.LTerm), 8888) AS LTCRED                                    
INTO #rawdata1
FROM #allregfinal AF1
/*WHERE NOT TermGPA IS NULL
ORDER BY TermGPA      
  */   


SELECT R1.TextTerm, R1.Term, R1.TermCalendarID, R1.StudentID, R1.StudentUID, 
       R1.LastName, R1.FirstName, R1.MiddleInitial, R1.CGPA, R1.CTCRED, R1.TCRED, R1.Program, R1.Advisor,
       R1.TermGPA, R1.TermGAPHours, R1.TTerm, R1.TTermNoSu, R1.LTerm, R1.LastTerm, R1.LastTermID,
       R1.LTermGPA, R1.LTermGAPHours, R1.LTCRED,
       (SELECT COUNT(*) FROM CAMS_Enterprise.dbo.SRAcademic SR18
        WHERE  SR18.TermCalendarID = R1.TermCalendarID AND SR18.StudentUID = R1.StudentUID AND
               SR18.Grade IN ('F', 'FX') AND 
               SR18.CategoryID = 1099 AND SR18.RegistrationStatus = 'Official') AS F_FX_CNT,
       ISNULL((SELECT SUM(SR108.Credits) FROM CAMS_Enterprise.dbo.SRAcademic SR108
        WHERE  SR108.TermCalendarID = R1.TermCalendarID AND SR108.StudentUID = R1.StudentUID AND
               SR108.Grade IN ('W', 'WF') AND 
               SR108.CategoryID = 1099 AND SR108.RegistrationStatus = 'Official'), 0) AS W_CREDS,
      ISNULL((SELECT SUM(SR12.Credits) FROM CAMS_Enterprise.dbo.SRAcademic SR12
        WHERE  SR12.TermCalendarID = R1.LastTermID AND SR12.StudentUID = R1.StudentUID AND
               SR12.Grade IN ('W', 'WF') AND 
               SR12.CategoryID = 1099 AND SR12.RegistrationStatus = 'Official'), 0) AS W_CREDS_Last,
       (SELECT COUNT(*) FROM CAMS_Enterprise.dbo.SRAcademic SR180
        WHERE  SR180.TermCalendarID = R1.TermCalendarID AND SR180.StudentUID = R1.StudentUID AND
               SR180.Grade IN ('W', 'WF') AND 
               SR180.CategoryID = 1099 AND SR180.RegistrationStatus = 'Official') AS W_CNT,
       (SELECT COUNT(*) FROM CAMS_Enterprise.dbo.SRAcademic SR181
        WHERE  SR181.TermCalendarID = R1.LastTermID AND SR181.StudentUID = R1.StudentUID AND
               SR181.Grade IN ('W', 'WF') AND 
               SR181.CategoryID = 1099 AND SR181.RegistrationStatus = 'Official') AS LW_CNT,
     (SELECT COUNT(*) FROM CAMS_Enterprise.dbo.SRAcademic SR182
        WHERE  SR182.TermCalendarID = R1.TermCalendarID AND SR182.StudentUID = R1.StudentUID AND
               SR182.CategoryID = 1099 AND SR182.RegistrationStatus = 'Official' AND NOT
               SR182.Grade IN ('AU', '')) AS Course_CNT,
     (SELECT COUNT(*) FROM CAMS_Enterprise.dbo.SRAcademic SR183
        WHERE  SR183.TermCalendarID = R1.LastTermID AND SR183.StudentUID = R1.StudentUID AND
               SR183.CategoryID = 1099 AND SR183.RegistrationStatus = 'Official' AND NOT
               SR183.Grade IN ('AU', '')) AS LCourse_CNT
INTO #rawdata2                                                                             
FROM #rawdata1 R1


SELECT R2.TextTerm, R2.Term, R2.TermCalendarID, R2.StudentID, R2.StudentUID, 
       R2.LastName, R2.FirstName, R2.MiddleInitial, R2.TCRED, R2.Program, R2.Advisor,
       R2.TermGPA, R2.TermGAPHours, R2.TTerm, R2.TTermNoSu, R2.LTerm, R2.LastTerm, R2.LastTermID,
       R2.LTermGPA, R2.LTermGAPHours, R2.LTCRED, R2.F_FX_CNT, R2.W_CREDS, R2.W_CREDS_Last,
       R2.W_CNT, R2.LW_CNT, R2.Course_CNT, R2.LCourse_CNT,
       CASE
           WHEN R2.TermGPA < 2.0000 AND R2.TermGAPHours > 0 AND 
                R2.LTermGPA < 2.0000  AND R2.LTermGAPHours > 0 THEN 'Yes'
           ELSE 'No'
        END AS D2PR,
        CASE 
            WHEN R2.F_FX_CNT > 2 THEN 'Yes'
            ELSE 'No'
        END AS DFFX,
        CASE 
           WHEN (R2.CTCRED < 16 and CAST(R2.CGPA AS Decimal(10,2)) < 1.0 AND R2.TermGAPHours > 0) then 'Yes'
           when (R2.CTCRED > 15 and R2.CTCRED < 31 and CAST(R2.CGPA AS Decimal(10,2)) < 1.25 AND R2.TermGAPHours > 0) then 'Yes'
           when (R2.CTCRED > 30 and R2.CTCRED < 46 and CAST(R2.CGPA AS Decimal(10,2)) < 1.50 AND R2.TermGAPHours > 0) then 'Yes'
           when (R2.CTCRED > 45 and CAST(R2.CGPA AS Decimal(10,2)) < 1.75 AND R2.TermGAPHours > 0) then 'Yes'
           else 'No'
        end AS DisGPA,
        CASE
          WHEN (((R2.W_CNT * 2) > R2.Course_CNT ) AND 
                ((R2.LW_CNT * 2) > R2.LCourse_CNT) ) then 'Yes'
          else 'No'
       end AS D2W
INTO #rawdata3               
FROM #rawdata2 R2 


SELECT R3.TextTerm, R3.Term, R3.TermCalendarID, R3.StudentID, R3.StudentUID, 
       R3.LastName, R3.FirstName, R3.MiddleInitial, R3.TCRED, R3.Program, R3.Advisor,
       R3.TermGPA, CAST(R3.TermGAPHours AS CHAR(8)) AS TermGPAHours, R3.TTerm, R3.TTermNoSu, R3.LTerm, R3.LastTerm, R3.LastTermID,
       R3.LTermGPA, CAST(R3.LTermGAPHours AS CHAR(8)) AS LTermGPAHours, R3.LTCRED, R3.F_FX_CNT, R3.W_CREDS, R3.W_CREDS_Last,
       R3.W_CNT, R3.LW_CNT, R3.Course_CNT, R3.LCourse_CNT, R3.D2PR, R3.DFFX, R3.DisGPA, R3.D2W,
       CASE
           WHEN R3.TermGPA < 2.000 AND R3.TermGAPHours > 0 AND R3.D2PR = 'No' AND R3.DFFX = 'No' AND
                R3.DisGPA = 'No' AND R3.D2W = 'No' THEN 'Probation'
           WHEN R3.D2PR = 'Yes' OR R3.DFFX = 'Yes' OR
                R3.DisGPA = 'Yes' OR R3.D2W = 'Yes' THEN 'Dismissal'
           ELSE 'None'
        END AS Letter,
        SAV1.Address1 + ' ' + SAV1.Address2 + ' ' + SAV1.Address3 AS Address,
        SAV1.City + ', ' + SAV1.State + '  ' + SAV1.ZipCode AS CSZ,
        @ULDate AS LDate, @UNSem AS NSem, SAV1.Phone1, SAV1.MobilePhone
INTO #rawdata4        
FROM #rawdata3 R3 
LEFT OUTER JOIN CAMS_Enterprise.dbo.CAMS_StudentAddressList_View SAV1
      ON (SAV1.StudentUID = R3.StudentUID AND SAV1.AddressType = 'Local' AND SAV1.ActiveFlag = 'Yes')
      
if @URType = 'preport' OR @URType = 'pletter'       
begin
     SELECT * FROM #rawdata4 WHERE Letter = 'Probation' ORDER BY LastName, FirstName, MiddleInitial
end
else if @URType = 'dreport' OR @URType = 'dletter'
begin
     SELECT * FROM #rawdata4 WHERE Letter = 'Dismissal' ORDER BY LastName, FirstName, MiddleInitial
end
else if @URType = 'pdsreport'          
begin
     SELECT * FROM #rawdata4 WHERE Letter IN ('Probation', 'Dismissal') ORDER BY LastName, FirstName, MiddleInitial
end             
else if @URType = 'pdplreport'          
begin
     SELECT * FROM #rawdata4 WHERE Letter IN ('Probation') ORDER BY LastName, FirstName, MiddleInitial
end             
else if @URType = 'pdcontact'          
begin
     SELECT * FROM #rawdata4 WHERE Letter IN ('Probation', 'Dismissal') ORDER BY Letter Desc, LastName, FirstName, MiddleInitial
end       
else if @URType = 'pd'          
begin
     SELECT * FROM #rawdata2 ORDER BY /*Letter Desc,*/ LastName, FirstName, MiddleInitial
end     
 DROP TABLE #allreg 
 DROP TABLE #allregplus       
 DROP TABLE #TGPA
 DROP TABLE #allregfinal
 DROP TABLE #rawdata1
 DROP TABLE #rawdata2
 DROP TABLE #rawdata3
 DROP TABLE #rawdata4
 DROP TABLE #allreg10 
 DROP TABLE #allregplus10 
 DROP TABLE #SLT
 DROP TABLE #STC
