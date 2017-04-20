USE [CAMS_Enterprise]
GO
/****** Object:  StoredProcedure [dbo].[TCC_Student_Advisor_Info_Sheet2]    Script Date: 10/21/2016 17:29:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--DROP TABLE #CurProg
--DROP TABLE #StudentInfo
--DROP TABLE #Scorebase

ALTER PROCEDURE [dbo].[TCC_Student_Advisor_Info_Sheet2] @UStudentID varchar(12), @UProgram varchar(60)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @SID1 int
    DECLARE @RP varchar(250)
    DECLARE @HG1 numeric(5,2)
    DECLARE @HG2 numeric(5,2)
    

    -- Insert statements for procedure here
	DECLARE @STUID int
	DECLARE @MTerm varchar(15)
	DECLARE @TCUM float
	DECLARE @MaxStatus varchar(15)

	-- drop table #studentinfo		    
			    
    
    -- Insert statements for procedure here

--SELECT "CAMS_Student_HighSchool_Scores_view"."TestName", "CAMS_Student_HighSchool_Scores_view"."LastName", "CAMS_Student_HighSchool_Scores_view"."FirstName", "CAMS_Student_HighSchool_Scores_view"."StudentID", "CAMS_Student_HighSchool_Scores_view"."StudentID", "CAMS_Student_HighSchool_Scores_view"."Score", "CAMS_Student_HighSchool_Scores_view"."Programs", "CAMS_Student_HighSchool_Scores_view"."City", "CAMS_Student_HighSchool_Scores_view"."ZipCode", "CAMS_Student_HighSchool_Scores_view"."ScoreName", "CAMS_Student_HighSchool_Scores_view"."Address1", "CAMS_Student_HighSchool_Scores_view"."Phone1", "CAMS_Student_HighSchool_Scores_view"."State", "CAMS_Student_HighSchool_Scores_view"."HSGPA1", "CAMS_Student_HighSchool_Scores_view"."HSGPA2"
--FROM   "CAMS_Enterprise"."dbo"."CAMS_Student_HighSchool_Scores_view" "CAMS_Student_HighSchool_Scores_view"
--WHERE  "CAMS_Student_HighSchool_Scores_view"."StudentID"= @UStudentID 
--ORDER BY "CAMS_Student_HighSchool_Scores_view"."StudentID"


set @SID1=cast(dbo.getStudentUIDFromID(@UStudentID) as int)

select top 1 @RP=dbo.CAMS_StudentBYORType1000_View.Programs
FROM dbo.CAMS_StudentBYORType1000_View
WHERe StudentID=@UStudentID

select top 1 @HG1=HSGPA1, @HG2=HSGPA2 FROM dbo.StudentHighSchool
WHERe StudentUID=@SID1




 -- Max Term query

		SET @MTerm = 
		(SELECT MAX(TCM.Term) AS MTerm
		FROM CAMS_Enterprise.dbo.SRAcademic SR1
		LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TCM
			  ON (TCM.TermCalendarID = SR1.TermCalendarID)
		WHERE SR1.StudentUID = @SID1 AND NOT Grade IN ('', 'TR')
		GROUP BY SR1.StudentUID)

		SET @MTerm = (SELECT
						case
						   when @MTerm IS NULL then 'None' else @MTerm
						end) 


		SET @TCUM =
		(SELECT TOP 1 GV2.CumGPA
		 FROM CAMS_Enterprise.dbo.CAMS_StudentCumulativeGPA_View GV2
		 LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TCM1
			  ON (TCM1.TermCalendarID = GV2.TermCalendarID)
		 WHERE GV2.StudentUID = @SID1 AND TCM1.Term = @MTerm)
		 
		 SET @TCUM = (SELECT
						case
						   when @TCUM IS NULL then '0.0' else @TCUM
						end) 
		 
		 -- Maxstatus query    
		 
		SET @MaxStatus = 
			(SELECT MAX(TC1.Term) 
			 FROM CAMS_Enterprise.dbo.StudentStatus SS1
			 LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
					ON (SS1.TermCalendarID = TC1.TermCalendarID)
			 WHERE SS1.StudentUID = @SID1)
		     

		 -- Maxstatus query when null

		SET @MaxStatus = (SELECT
						   case
							  when @MaxStatus IS NULL then 'No Status Available' else @MaxStatus
						   end) 

		    
		  -- current program query

		 SELECT TOP 1 @SID1 AS StudentUID,
				   case  
					   when @MaxStatus = 'No Status Available' then 'No Current Program Available'
					   when MM1.MajorMinorName IS NULL then 'No Current Program Available'
					   else '(' + TC1.TextTerm + ')' + '  ' + MM1.MajorMinorName
				   end AS CProg
		 INTO #CurProg
		 FROM CAMS_Enterprise.dbo.StudentStatus SS1
		 LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
			  ON (SS1.TermCalendarID = TC1.TermCalendarID)
		 LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentProgram SP1
			  ON (SS1.StudentStatusID = SP1.StudentStatusID)
		 LEFT OUTER JOIN CAMS_Enterprise.dbo.MajorMinor MM1
			  ON (SP1.MajorProgramID = MM1.MajorMinorID)
		 WHERE SS1.StudentUID =@SID1 AND SP1.SequenceNo = 0 AND 
			   TC1.Term = @MaxStatus
		 
		


		-- student info table

		SELECT ST.StudentUID, ST.StudentID, ST.FirstName ,ST.LastName,
			   ADR1.Address1 + ' ' + ADR1.Address2 + ' ' + ADR1.Address3 AS Address,
			   ADR1.City , GL3.DisplayText as State, ADR1.ZipCode, ADR1.Phone1, GL4.DisplayText AS IProg, CP1.CProg
		INTO #StudentInfo       
		FROM CAMS_Enterprise.dbo.Student ST
		LEFT OUTER JOIN CAMS_Enterprise.dbo.Student_Address STA1
			   ON (ST.StudentUID = STA1.StudentID)
		LEFT OUTER JOIN CAMS_Enterprise.dbo.Address ADR1
			   ON (STA1.AddressID = ADR1.AddressID)
		LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL2
			   ON (ADR1.AddressTypeID = GL2.UniqueId)
		LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL3
			   ON (ADR1.StateID = GL3.UniqueId)
		LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL4
			   ON (ST.UserDefinedFieldID = GL4.UniqueId)
		LEFT OUTER JOIN #CurProg CP1
			   ON (ST.StudentUID = CP1.StudentUID)              
		WHERE ST.StudentUID = @SID1 AND GL2.DisplayText = 'Local' AND ADR1.ActiveFlag = 'Yes'


		 DECLARE @CP varchar(25)
		 DECLARE @IPR varchar(25) 
		 DECLARE @adr1 varchar(100) 
		 DECLARE @ct varchar(25) 
		 DECLARE @zp varchar(25)          
		 DECLARE @st1 varchar(25)
		 DECLARE @lst varchar(35)          
		 DECLARE @fst varchar(35)                    
		 DECLARE @ph1 varchar(25)          
		 
		 Select top 1 @lst=lastname, @fst=firstname, @CP=CProg, @IPR=IProg, @adr1=address, @ct=City, @zp=ZipCode, @St1=state,@ph1=phone1 from #studentinfo
		 


select TC.* , 0 as Score1, 0 as Score2, 0 as Score3, 0 as Score4 , 
        0 as Score5, 0 as Score6, 0 as Score7
       INTO #ScoreBase 
 FROM
(
SELECT @SID1 as OwnerID,  TA.CAMS_TestRefID,TA.TestName, ISNULL(TB.ScoreName,'NA') as ScoreName, TB.Score, TB.Percentile, TB.ScoreStatus, TB.UsedForPlacement, 
               TB.TestDate , @HG1 as HSGPA1, @HG2 AS HSGPA2, @SID1 as StudentUID, @UStudentID as StudentID, @lst as LastName, @fst as FirstName, @CP as Programs, 'Local' as AddressType, @adr1 as Address1, @ct as City, 
               @st1 as State, TB.County, @zp as ZipCode, @ph1 as Phone1, TB.FNAME, @IPR as IProg, @CP as CProg, TB.TORD11, TB.DORD11, TB.Country, TB.Head11, TB.Head21, TB.Head31, TB.Head41, 
               TB.Head51, TB.Head61, TB.Head71, @UProgram as RProg11
FROM  (SELECT CAMS_TestRefID, TestName, Description, TestCode, TestDateLabelOn, ScoresSourceLabelOn, StateTakenLabelOn, TestTypeLabelOn, ActiveFlag, 
                              CAMSProtect, USERProtect, CustomLabel1, CustomLabel2, CustomLabel3, CustomLabel4, CustomLabel5, CustomLabel6, InsertUserID, InsertTime, 
                              UpdateUserID, UpdateTime, TestGroupID
               FROM   dbo.CAMS_TestRef
               WHERE (CAMS_TestRefID IN (8,12, 13, 14, 15, 18))) AS TA LEFT OUTER JOIN
                   (SELECT CAMS_Test_1.OwnerID, CAMS_Test_1.CAMS_TestID, CAMS_Test_1.CAMS_TestRefID, dbo.CAMS_TestScore_View.ScoreName, 
                                   dbo.CAMS_TestScore_View.Score, dbo.CAMS_TestScore_View.Percentile, dbo.CAMS_TestScore_View.ScoreStatus, 
                                   dbo.CAMS_TestScore_View.UsedForPlacement, CAMS_Test_1.TestDate, dbo.StudentHighSchool.HSGPA1, dbo.StudentHighSchool.HSGPA2, 
                                   dbo.CAMS_StudentBYORType1000_View.StudentUID, dbo.CAMS_StudentBYORType1000_View.StudentID, 
                                   dbo.CAMS_StudentBYORType1000_View.LastName, dbo.CAMS_StudentBYORType1000_View.FirstName, 
                                   dbo.CAMS_StudentBYORType1000_View.Programs, dbo.CAMS_StudentBYORType1000_View.AddressType, 
                                   dbo.CAMS_StudentBYORType1000_View.Address1, dbo.CAMS_StudentBYORType1000_View.City, dbo.CAMS_StudentBYORType1000_View.State, 
                                   dbo.CAMS_StudentBYORType1000_View.County, dbo.CAMS_StudentBYORType1000_View.ZipCode, dbo.CAMS_StudentBYORType1000_View.Phone1, 
                                   dbo.CAMS_StudentBYORType1000_View.Country, '' AS FNAME, @IPR AS IProg, @CP AS CProg, '' AS TORD11, '' AS DORD11, '' AS Head11, '' AS Head21, 
                                   '' AS Head31, '' AS Head41, '' AS Head51, '' AS Head61, '' AS Head71, @UProgram AS RProg11
                    FROM   dbo.CAMS_TestScore_View RIGHT OUTER JOIN
                                   dbo.CAMS_StudentBYORType1000_View LEFT OUTER JOIN
                                   dbo.StudentHighSchool ON dbo.CAMS_StudentBYORType1000_View.StudentUID = dbo.StudentHighSchool.StudentUID RIGHT OUTER JOIN
                                   dbo.CAMS_Test AS CAMS_Test_1 ON dbo.CAMS_StudentBYORType1000_View.StudentUID = CAMS_Test_1.OwnerID ON 
                                   dbo.CAMS_TestScore_View.CAMS_TestID = CAMS_Test_1.CAMS_TestID
                    WHERE (CAMS_Test_1.OwnerID = @SID1) AND (dbo.CAMS_StudentBYORType1000_View.AddressType LIKE '%Local%')) AS TB ON 
               TA.CAMS_TestRefID = TB.CAMS_TestRefID
--Union all

---- Other College

--SELECT SI6.StudentUID as OwnerID, 
--       99 as CAMS_TestRefID,
--       'Other Colleges' AS TestName,
--       COL1.CollegeName AS ScoreName,
--       0.0 as Score, 
--       0.0 as Percentile, '' as ScoreStatus, 
--                 '' as UsedForPlacement , '1900-01-01' as TestDate, @HG1 as HSGPA1, @HG2 as HSGPA2,SI6.StudentUID, 
--                 SI6.StudentID, SI6.LastName, SI6.FirstName,  SI6.CProg as Programs, 
--                   'Local' as Addresstype, SI6.Address as Address1, SI6.City, SI6.State,  '' as County, SI6.Zipcode, SI6.Phone1 as Phone1, '' as FNAME, SI6.IProg, SI6.CProg ,
--		 '' AS DORD11, 15 AS TORD11,  '' as Country,  '' AS Head11, '' AS Head21,
--        '' AS Head31,
--        RTRIM(CAST(CAST(SC8.GradePoint AS Decimal(5,1)) AS Char(10))) + '  out of  ' + 
--        CAST(CAST(SC8.GradePointOf AS Decimal(5,1)) AS Char(10)) AS Head41,
--        '' AS Head51, '' AS Head61, '' AS Head71, @UProgram AS RProg11	
        
--FROM CAMS_Enterprise.dbo.StudentCollege SC8 
--LEFT OUTER JOIN CAMS_Enterprise.dbo.Colleges COL1
--      ON (SC8.CollegeID = COL1.CollegeID)       
--LEFT OUTER JOIN #StudentInfo SI6
--      ON (SI6.StudentUID = SC8.StudentUID)
--WHERE SI6.StudentUID = @SID1 AND NOT COL1.CollegeName = 'TROCAIRE COLLEGE'
) TC

-- select * from #ScoreBase

-- ACCUPLACER Grades

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'ACCUPLACER' AS TestName, 'Test Date' AS TestDate, 'Reading' AS Head1, 'Sentence Skills' AS Head2,
        'Arithmetic' AS Head3, 'Algebra' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/01/1900' AS DORD, 4 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID, (SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Reading', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Sentence Skills', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Arithmetic', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head3,        
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Algebra', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head4,    
       case
          when NOT (SI.Score5 IS NULL OR SI.Score5 = 0) then CAST(CAST(SI.Score5 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head5,       
       case
          when NOT (SI.Score6 IS NULL OR SI.Score6 = 0) then CAST(CAST(SI.Score6 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head6,       
       case
          when NOT (SI.Score7 IS NULL OR SI.Score7 = 0) then CAST(CAST(SI.Score7 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=12
) RC
UNION ALL

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg,  
--SELECT SI1.StudentUID, SI1.StudentID, SI1.FName, SI1.Address, SI1.CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'ACCUPLACER' AS TestName, '(Cut-offs)' AS TestDate, '(70)' AS Head1, '(82)' AS Head2,
        '(50)' AS Head3, '(58)' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/04/1900' AS DORD, 4 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1  

UNION ALL

-- TEAS Grades

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'TEAS' AS TestName, 'Test Date' AS TestDate, 'Reading' AS Head1, 'Math' AS Head2,
        'Science' AS Head3, 'Eng Lang Skills' AS Head4,
        'Overall' AS Head5, '' AS Head6, '' AS Head7, '01/01/1900' AS DORD, 12 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID,(SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Reading', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Math', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Science', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head3,        
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Eng Lang Skills', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head4,    
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Overall', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head5,       
       case
          when NOT (SI.Score6 IS NULL OR SI.Score6 = 0) then CAST(CAST(SI.Score6 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head6,       
       case
          when NOT (SI.Score7 IS NULL OR SI.Score7 = 0) then CAST(CAST(SI.Score7 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=13
) RC
UNION ALL

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg,  
--SELECT SI1.StudentUID, SI1.StudentID, SI1.FName, SI1.Address, SI1.CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'TEAS' AS TestName, '(Cut-offs)' AS TestDate, '(70)' AS Head1, '(82)' AS Head2,
        '(50)' AS Head3, '(58)' AS Head4,
        'Overall' AS Head5, '' AS Head6, '' AS Head7, '01/04/1900' AS DORD, 12 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1  

Union All

-- HS Biology Grades

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'HS Biology' AS TestName, 'Test Date' AS TestDate, 'Final' AS Head1, 'Regents' AS Head2,
        '' AS Head3, '' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/01/1900' AS DORD, 7 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID,(SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Final', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Regents', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ''
	   AS Head3,        
       ''
       AS Head4,    
       ''
       AS Head5,       
       case
          when NOT (SI.Score6 IS NULL OR SI.Score6 = 0) then CAST(CAST(SI.Score6 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head6,       
       case
          when NOT (SI.Score7 IS NULL OR SI.Score7 = 0) then CAST(CAST(SI.Score7 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=14
) RC

union all

-- HS Chemistry Grades

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'HS Chemistry' AS TestName, 'Test Date' AS TestDate, 'Final' AS Head1, 'Regents' AS Head2,
        '' AS Head3, '' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/01/1900' AS DORD, 8 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID,(SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Final', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Regents', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ''
	   AS Head3,        
       ''
       AS Head4,    
       ''
       AS Head5,       
       case
          when NOT (SI.Score6 IS NULL OR SI.Score6 = 0) then CAST(CAST(SI.Score6 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head6,       
       case
          when NOT (SI.Score7 IS NULL OR SI.Score7 = 0) then CAST(CAST(SI.Score7 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=15
) RC

union all

-- HS Physics Grades

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'HS Physics' AS TestName, 'Test Date' AS TestDate, 'Final' AS Head1, 'Regents' AS Head2,
        '' AS Head3, '' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/01/1900' AS DORD, 11 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID,(SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Final', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Regents', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ''
	   AS Head3,        
       ''
       AS Head4,    
       ''
       AS Head5,       
       case
          when NOT (SI.Score6 IS NULL OR SI.Score6 = 0) then CAST(CAST(SI.Score6 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head6,       
       case
          when NOT (SI.Score7 IS NULL OR SI.Score7 = 0) then CAST(CAST(SI.Score7 AS Decimal(5,1)) AS Char(10))
          else ''
       end AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=18
) RC

UNION ALL

-- GED Grades

SELECT SI2.StudentUID, SI2.StudentID,(SI2.FirstName+' '+SI2.LastName) as FName, SI2.Address, (SI2.City+', ' +SI2.State+' '+SI2.ZipCode) as CSZ, SI2.Phone1, SI2.IProg, SI2.CProg,  
-- SELECT SI2.StudentUID, SI2.StudentID, SI2.FName, SI2.Address, SI2.CSZ, SI2.Phone1, SI2.IProg, SI2.CProg, 
        'GED' AS TestName, 'Test Date' AS TestDate, 'Total' AS Head1, 'Soc ST' AS Head2,
        'Science' AS Head3, 'Lit and Arts' AS Head4, 'Math' AS Head5, 'Writing' AS Head6, 
        'Std Average' AS Head7, '01/01/1900' AS DORD, 6 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI2
WHERE SI2.StudentUID = @SID1

union all

SELECT DISTINCT RC.* from
(
SELECT SI.StudentUID, SI.StudentID, (SI.FirstName+' '+SI.LastName) as FName, SI.Address1 As Address, 
     (SI.City+', ' +SI.State+' '+SI.ZipCode) as CSZ, SI.Phone1, 
      SI.IProg, SI.CProg, SI.TestName as TestName, 
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else ''
       end AS TestDate,
        ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Total', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head1,
    	ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Soc ST', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head2,  
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Science', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
	   AS Head3,        
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Lit and Arts', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head4,    
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Math', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head5,       
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Writing', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head6,       
       ISNULL((cast( (select [dbo].[getStudentHSScoreByDateAndTestName] (SI.StudentID, 'Std Average', SI.CAMS_TestRefID, SI.TestDate)) as char(10))),'')
       AS Head7,
       case
          when NOT SI.TestDate IS NULL then CONVERT(varchar, SI.TestDate, 101)
          else '01/10/1900'
       end AS DORD, 
       case 
          when SI.TestName = 'ACCUPLACER' then 4
          when SI.TestName = 'Computer Literacy' then 5
          when SI.TestName = 'GED' then 6 
          when SI.TestName = 'HS Biology' then 7
          when SI.TestName = 'HS Chemistry' then 8
          when SI.TestName = 'HS Math I' then 9
          when SI.TestName = 'HS Math II' then 10
          when SI.TestName = 'HS Physics' then 11
          when SI.TestName = 'TEAS' then 12
          else ''
       end AS TORD, @UProgram AS RProg
FROM #ScoreBase SI
where SI.CAMS_TestRefID=8
) RC
UNION ALL

SELECT SI1.StudentUID, SI1.StudentID,(SI1.FirstName+' '+SI1.LastName) as FName, SI1.Address, (SI1.City+', ' +SI1.State+' '+SI1.ZipCode) as CSZ, SI1.Phone1, SI1.IProg, SI1.CProg,  
--SELECT SI1.StudentUID, SI1.StudentID, SI1.FName, SI1.Address, SI1.CSZ, SI1.Phone1, SI1.IProg, SI1.CProg, 
        'GED' AS TestName, '(Cut-offs)' AS TestDate, '(70)' AS Head1, '(82)' AS Head2,
        '(50)' AS Head3, '(58)' AS Head4,
        '' AS Head5, '' AS Head6, '' AS Head7, '01/04/1900' AS DORD, 6 AS TORD, @UProgram AS RProg
FROM #StudentInfo SI1
WHERE SI1.StudentUID = @SID1  



--Select * from #ScoreBase where CAMS_TestRefID=12 and ScoreName='Algebra'

DROP TABLE #StudentInfo
DROP TABLE #CurProg
DROP TABLE #ScoreBase


