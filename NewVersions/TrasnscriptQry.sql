
-- Determining Transcript details

--drop table #tmpProgram
go


 WITH
TermStatus AS
(
  SELECT ts.RptUser, ts.StudentUID, ts.StudentStatusID, ts.CollegeLevelID,    
    RANK() OVER(PARTITION BY ts.RptUser, ts.StudentUID ORDER BY ts.Term DESC, ts.StudentStatusID DESC) AS TermRank
  FROM dbo.tmpRptTranscriptStudentStatus ts
),
Programs AS
(
  SELECT ts.RptUser, ts.StudentUID, ts.StudentStatusID, ts.CollegeLevelID, sp.AdvisorID,
    mj.MajorMinorName AS MajorName,
    mn.MajorMinorName AS MinorName,
    DENSE_RANK() OVER
    (
      PARTITION BY ts.RptUser, ts.StudentUID
      ORDER BY CASE WHEN (mj.MajorMinorName = '' AND mn.MajorMinorName = '') THEN 99999 ELSE 0 END ASC, sp.SequenceNo ASC, sp.StudentProgramID ASC
    ) AS ActiveMajorRank
  FROM TermStatus ts
    INNER JOIN dbo.StudentProgram sp ON ts.StudentStatusID = sp.StudentStatusID
    INNER JOIN dbo.Glossary g ON sp.FTPTStatusID = g.UniqueID
    INNER JOIN dbo.MajorMinor mj ON sp.MajorProgramID = mj.MajorMinorID
    INNER JOIN dbo.MajorMinor mn ON sp.MinorProgramID = mn.MajorMinorID
  WHERE ts.TermRank = 1
    AND g.DisplayText != 'Withdrawn'
)
SELECT p.RptUser, p.StudentUID, p.StudentStatusID,
  ISNULL(cl.DisplayText, '') AS CollegeLevel,
  ISNULL(a.FormalName, '') AS Advisor,
  ISNULL(p1.MajorName, '') AS MajorProgram1,
  ISNULL(p2.MajorName, '') AS MajorProgram2,
  ISNULL(p3.MajorName, '') AS MajorProgram3,
  ISNULL(p4.MajorName, '') AS MajorProgram4,
  ISNULL(p1.MinorName, '') AS MinorProgram1,
  ISNULL(p2.MinorName, '') AS MinorProgram2,
  ISNULL(p3.MinorName, '') AS MinorProgram3,
  ISNULL(p4.MinorName, '') AS MinorProgram4
  into #tmpProgram
FROM TermStatus p
  LEFT JOIN Programs p1 ON p.StudentUID = p1.StudentUID
    AND p.RptUser = p1.RptUser
    AND p1.ActiveMajorRank = 1
  LEFT JOIN Programs p2 ON p.StudentUID = p2.StudentUID
    AND p.RptUser = p2.RptUser
    AND p2.ActiveMajorRank = 2
  LEFT JOIN Programs p3 ON p.StudentUID = p3.StudentUID
    AND p.RptUser = p3.RptUser
    AND p3.ActiveMajorRank = 3
  LEFT JOIN Programs p4 ON p.StudentUID = p4.StudentUID
    AND p.RptUser = p4.RptUser
    AND p4.ActiveMajorRank = 4
  LEFT JOIN dbo.Glossary cl ON p.CollegeLevelID = cl.UniqueID
  LEFT JOIN dbo.Advisors a ON p1.AdvisorID = a.AdvisorID
WHERE p.TermRank = 1



-- Start Of Transcript 
 
 SELECT "TmpRptTranscriptAddresses"."City", "TmpRptTranscriptAddresses"."State", "TmpRptTranscriptAddresses"."ZipCode", "TmpRptTranscriptSRAcademic"."CollegeName", "TmpRptTranscriptSRAcademic"."Category", "TmpRptTranscriptSRAcademic"."Department", "TmpRptTranscriptSRAcademic"."Course", "TmpRptTranscriptSRAcademic"."CourseType", "TmpRptTranscriptSRAcademic"."CourseName", "TmpRptTranscriptSRAcademic"."GPAGrouping", "TmpRptTranscriptAddresses"."LastName", "TmpRptTranscriptAddresses"."FirstName", "TmpRptTranscriptAddresses"."MiddleName", "CAMS_rptStudentTranscript1"."StudentUID", "CAMS_rptStudentTranscript1"."LastName", "CAMS_rptStudentTranscript1"."FirstName", "CAMS_rptStudentTranscript1"."MiddleName", "TmpRptTranscriptSRAcademic"."TermSeq", "TmpRptTranscriptStudentStatus"."CommentPosition", "TmpRptTranscriptAddresses"."Address1", "TmpRptTranscriptAddresses"."Address2", "CAMS_rptStudentTranscript1"."StudentID", "TmpRptTranscriptSRAcademic"."StudentUID", "TmpRptTranscriptSRAcademic"."TranscriptAttHrs", "TmpRptTranscriptSRAcademic"."CumulativeEarned", "TmpRptTranscriptSRAcademic"."CumulativeGPAHours", "TmpRptTranscriptSRAcademic"."OverallGradePoint", "tmpRptTranscriptStudentList"."RptUser", "TmpRptTranscriptSRAcademic"."RptUser", "TmpRptTranscriptSRAcademic"."TranscriptSort", "CAMS_rptTranscriptStudentProgram1"."MajorProgram1", "CAMS_rptTranscriptStudentProgram1"."MajorProgram2", "CAMS_rptTranscriptStudentProgram1"."MajorProgram3", "TmpRptTranscriptAddresses"."MailToName", "CAMS_rptStudentTranscript1"."BirthDate", "TmpRptTranscriptSRAcademic"."TermCalendarID", "TmpRptTranscriptStudentStatus"."TranscriptComment"
 FROM   ((((
  
 (SELECT dbo.Student.StudentUID, dbo.Student.StudentID, g1.DisplayText AS StudentType, dbo.Student.Salutation, dbo.Student.LastName, dbo.Student.FirstName, 
               dbo.Student.MiddleInitial AS MiddleName, dbo.Student.Suffix, dbo.Student.PreferredName, dbo.Student.MaidenName, dbo.Student.AdmitDate, 
               dbo.Student.BirthDate, dbo.Student.DateAccepted, dbo.Student.DateEntered, dbo.Student.BoxNumber, dbo.Student.StudentSSN, dbo.Student.WithdrawnDate, 
               ISNULL(m1.MajorMinorName, CAST('' AS varchar(50))) AS LastMajorProgram, ISNULL(sd.Gender, '') AS Gender, ISNULL(a.FormalName, CAST('' AS varchar(180))) 
               AS LastAdvisor, ISNULL(ca.DisplayText, '') AS LastCollegeLevel, ISNULL(m2.MajorMinorName, CAST('' AS varchar(50))) AS LastMajorProgram2, 
               ISNULL(m3.MajorMinorName, CAST('' AS varchar(50))) AS LastMajorProgram3, ISNULL(m4.MajorMinorName, CAST('' AS varchar(50))) AS LastMinorProgram, 
               ISNULL(m5.MajorMinorName, CAST('' AS varchar(50))) AS LastMinorProgram2, ISNULL(m6.MajorMinorName, CAST('' AS varchar(50))) AS LastMinorProgram3
FROM  dbo.Student INNER JOIN
               dbo.Glossary AS g1 ON g1.UniqueId = dbo.Student.TypeID LEFT OUTER JOIN
               dbo.StudentDemographics AS sd ON sd.StudentUID = dbo.Student.StudentUID LEFT OUTER JOIN
               -- dbo.CAMS_LatestStudentCollegeLevel_View AS cl 
               ((
               SELECT ss1.StudentUID, g11.DisplayText
				FROM  
				--dbo.CAMS_LatestStudentStatus_View ss1 
				
				(
				SELECT StudentUID, StudentStatusID, TermCalendarID, CollegeLevelID
					FROM  dbo.StudentStatus AS ss
					WHERE (TermCalendarID =
                   (SELECT TOP (1) t.TermCalendarID
                    FROM   dbo.TermCalendar AS t INNER JOIN
                                   dbo.StudentStatus AS s ON t.TermCalendarID = s.TermCalendarID
                    WHERE (s.StudentUID = ss.StudentUID)
                    ORDER BY t.Term DESC))
                    ) ss1
				
				INNER JOIN
               dbo.RegCollegeLevelRef AS g11 ON ss1.CollegeLevelID = g11.UniqueID
               )) ca
               
               ON ca.StudentUID = dbo.Student.StudentUID LEFT OUTER JOIN
               
               --dbo.CAMS_LatestStudentPrograms_View 
               
               (SELECT StudentUID, MAX(CASE WHEN Rank = 1 THEN Pivoted.StudentProgramID ELSE NULL END) AS LatestProgram1ID, 
               MAX(CASE WHEN Rank = 1 THEN Pivoted.AdvisorID ELSE NULL END) AS LatestProgram1AdvisorID, 
               MAX(CASE WHEN Rank = 2 THEN Pivoted.StudentProgramID ELSE NULL END) AS LatestProgram2ID, 
               MAX(CASE WHEN Rank = 2 THEN Pivoted.AdvisorID ELSE NULL END) AS LatestProgram2AdvisorID, 
               MAX(CASE WHEN Rank = 3 THEN Pivoted.StudentProgramID ELSE NULL END) AS LatestProgram3ID, 
               MAX(CASE WHEN Rank = 3 THEN Pivoted.AdvisorID ELSE NULL END) AS LatestProgram3AdvisorID
				FROM  (SELECT ss.StudentUID, sp.StudentProgramID, sp.AdvisorID,
                                  (SELECT COUNT(*) AS Expr1
                                   FROM   dbo.StudentProgram AS SP2
                                   WHERE (StudentStatusID = ss.StudentStatusID) AND (CAST(RIGHT('00' + CAST(SequenceNo AS VARCHAR(2)), 2) 
                                                  + RIGHT('00000000' + CAST(StudentProgramID AS VARCHAR(8)), 8) AS BIGINT) < CAST(RIGHT('00' + CAST(sp.SequenceNo AS VARCHAR(2)), 2) 
                                                  + RIGHT('00000000' + CAST(sp.StudentProgramID AS VARCHAR(8)), 8) AS BIGINT))) + 1 AS Rank
               FROM   dbo.StudentProgram AS sp INNER JOIN
                           --  dbo.CAMS_LatestStudentStatusStudentProgram_View AS ss 
                              
                              (SELECT StudentUID, StudentStatusID, TermCalendarID, CollegeLevelID
								FROM  dbo.StudentStatus AS ss
								WHERE (TermCalendarID =
												   (SELECT TOP (1) t.TermCalendarID
													FROM   dbo.TermCalendar AS t INNER JOIN
																   dbo.StudentStatus AS s ON t.TermCalendarID = s.TermCalendarID INNER JOIN
																   dbo.StudentProgram AS sp ON s.StudentStatusID = sp.StudentStatusID
													WHERE (s.StudentUID = ss.StudentUID)
													ORDER BY t.Term DESC))) ss
                              
                              
                              ON sp.StudentStatusID = ss.StudentStatusID) AS Pivoted
GROUP BY StudentUID) sp 
               
               ON sp.StudentUID = dbo.Student.StudentUID LEFT OUTER JOIN
               dbo.StudentProgram AS sp1 ON sp1.StudentProgramID = sp.LatestProgram1ID LEFT OUTER JOIN
               dbo.StudentProgram AS sp2 ON sp2.StudentProgramID = sp.LatestProgram2ID LEFT OUTER JOIN
               dbo.StudentProgram AS sp3 ON sp3.StudentProgramID = sp.LatestProgram3ID LEFT OUTER JOIN
               dbo.MajorMinor AS m1 ON sp1.MajorProgramID = m1.MajorMinorID LEFT OUTER JOIN
               dbo.MajorMinor AS m2 ON sp2.MajorProgramID = m2.MajorMinorID LEFT OUTER JOIN
               dbo.MajorMinor AS m3 ON sp3.MajorProgramID = m3.MajorMinorID LEFT OUTER JOIN
               dbo.Advisors AS a ON a.AdvisorID = sp.LatestProgram1AdvisorID LEFT OUTER JOIN
               dbo.MajorMinor AS m4 ON sp1.MinorProgramID = m4.MajorMinorID LEFT OUTER JOIN
               dbo.MajorMinor AS m5 ON sp2.MinorProgramID = m5.MajorMinorID LEFT OUTER JOIN
               dbo.MajorMinor AS m6 ON sp3.MinorProgramID = m6.MajorMinorID
 ) CAMS_rptStudentTranscript1
 
 INNER JOIN "CAMS_Enterprise"."dbo"."tmpRptTranscriptStudentList" "tmpRptTranscriptStudentList" 
 ON "CAMS_rptStudentTranscript1"."StudentUID"="tmpRptTranscriptStudentList"."StudentUID") 
 INNER JOIN "CAMS_Enterprise"."dbo"."tmpRptTranscriptSRAcademic" "TmpRptTranscriptSRAcademic" 
 ON ("tmpRptTranscriptStudentList"."RptUser"="TmpRptTranscriptSRAcademic"."RptUser") 
 AND ("tmpRptTranscriptStudentList"."StudentUID"="TmpRptTranscriptSRAcademic"."StudentUID")) 
 LEFT OUTER JOIN "CAMS_Enterprise"."dbo"."tmpRptTranscriptAddresses" "TmpRptTranscriptAddresses" 
 ON ("tmpRptTranscriptStudentList"."RptUser"="TmpRptTranscriptAddresses"."RptUser") 
 AND ("tmpRptTranscriptStudentList"."StudentUID"="TmpRptTranscriptAddresses"."StudentUID")) 
 LEFT OUTER JOIN 
 #tmpProgram CAMS_rptTranscriptStudentProgram1
  
 ON ("tmpRptTranscriptStudentList"."RptUser"="CAMS_rptTranscriptStudentProgram1"."RptUser") 
 AND ("tmpRptTranscriptStudentList"."StudentUID"="CAMS_rptTranscriptStudentProgram1"."StudentUID")) 
 LEFT OUTER JOIN "CAMS_Enterprise"."dbo"."tmpRptTranscriptStudentStatus" "TmpRptTranscriptStudentStatus" 
 ON ("TmpRptTranscriptSRAcademic"."StudentStatusID"="TmpRptTranscriptStudentStatus"."StudentStatusID") 
 AND ("TmpRptTranscriptSRAcademic"."RptUser"="TmpRptTranscriptStudentStatus"."RptUser")
 WHERE  "tmpRptTranscriptStudentList"."RptUser"='TCCAMSMGR'

--select * from 
--#tmpProgram CAMS_rptTranscriptStudentProgram1
-- inner join
--  tmpRptTranscriptStudentList tmpRptTranscriptStudentList1
-- ON ("tmpRptTranscriptStudentList1"."RptUser"="CAMS_rptTranscriptStudentProgram1"."RptUser")
 

drop table #tmpProgram