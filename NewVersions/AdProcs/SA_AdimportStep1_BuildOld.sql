USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep1_BuildOld]    Script Date: 7/20/2017 10:23:26 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep1_BuildOld]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep1_BuildOld]    Script Date: 7/20/2017 10:23:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep1_BuildOld]
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
	@TermParam varchar(12),
	@BatchParam varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
	

DECLARE @RanString1 varchar(200)
DECLARE @RanString2 varchar(200)
DECLARE @RanString3 varchar(200)
DECLARE @RanString4 varchar(200)


SET @RanString1 = 'WXYZABCDEFGHGLMNPQRSTUVWXYZABCDEFGHRLMNPQRSTUVWXYZABCDEFGHMLMABCDEFGHALMNPQRSTUVWXYZABCDEFGHBLMNPQRSTUV'
SET @RanString2 = '7899876543298765432234567892345678998765432987623456789876234567892345678998765432987654322345678923456'
SET @RanString3 = 'ghbamnpqrstuvwxyzabcdefghprmnpqrstuvwxyzabcdefghrsmnpqrstuvwxyzabcdefghadmabcdefghaemnpqrstuvwxyzabcdef'
SET @RanString4 = 'ABCDEFGH456789abcdefghR6mn623456789ABCDEFGHdLMNPQRSTUVWY323456789abcdefghG8mnopqrstuvwyz98765432a456789'

SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Sta' AS AType, 'Act' AS AState, sAMAccountName, employeeID
INTO #Firsttry
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Staff,DC=Trocaire,DC=local''')
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Fac' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Faculty,DC=Trocaire,DC=local'' where  sAMAccountName =''*'' ')

INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn < ''Caaaaa''
      ORDER BY mailnickname')
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Caaaa''AND sn < ''Eaaaaa''
      ORDER BY mailnickname') 
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Eaaaa''AND sn < ''Gaaaaa''
      ORDER BY mailnickname') 
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Gaaaa''AND sn < ''Kaaaaa''
      ORDER BY mailnickname')      

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Kaaaa''AND sn < ''Maaaaa''
      ORDER BY mailnickname')   

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Maaaa''AND sn < ''Paaaaa''
      ORDER BY mailnickname') 

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Paaaa''AND sn < ''Saaaaa''
      ORDER BY mailnickname')
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Saaaa''AND sn < ''Uaaaaa''
      ORDER BY mailnickname')      

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Uaaaa''
      ORDER BY mailnickname')
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Sta' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Staff Accounts,OU=Staff,DC=Trocaire,DC=local''')

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Sta' AS AType, 'Maf' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=MailFowards,OU=Staff,DC=Trocaire,DC=local''') 

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Fac' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Faculty Accounts,OU=Faculty,DC=Trocaire,DC=local''')

INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn < ''Caaaaa''
      ORDER BY mailnickname')
      
      INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Caaaa''AND sn < ''Gaaaaa''
      ORDER BY mailnickname')
      
INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
            WHERE sn > ''Gaaaa''AND sn < ''Kaaaaa''
      ORDER BY mailnickname')
            
INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Kaaaa''AND sn < ''Maaaaa''
      ORDER BY mailnickname')
 
INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Maaaa''AND sn < ''Paaaaa''
      ORDER BY mailnickname')      

INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Paaaa''AND sn < ''Saaaaa''
      ORDER BY mailnickname') 

INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Saaaa''AND sn < ''Uaaaaa''
      ORDER BY mailnickname')                      

INSERT INTO #Firsttry
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID
      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Uaaaa''
      ORDER BY mailnickname')  
      
      
SELECT employeeID, COUNT(*) AS CNT
INTO #Dub
FROM #Firsttry
GROUP BY employeeID
HAVING COUNT(*) > 1 

/*SELECT *
FROM #Firsttry
WHERE employeeID IN (SELECT employeeID FROM #Dub)
ORDER BY LastName, FirstName   
*/            
      
SELECT DISTINCT TC1.TextTerm AS Term,
               ST1.StudentUID, ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) AS FirstName, ST1.MiddleInitial, MM1.MajorMinorName AS DegreeProgram,
               LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) AS USERID,
               LTRIM(RTRIM(ST1.LastName)) + CAST(ST1.StudentUID AS Char(8)) AS PPP,
                CAST(ST1.StudentUID * 2244 AS varchar(20)) +
                CAST(ST1.StudentUID * 1133 AS varchar(20)) +
                CAST(ST1.StudentUID * 2224 AS varchar(20)) AS NUMGEN1,
               case
                   when exists (SELECT F1.* FROM #Firsttry F1 WHERE ST1.StudentID = F1.employeeID) then
                                (SELECT TOP 1 F1.UserID + '  ' + F1.AState FROM #Firsttry F1 WHERE ST1.StudentID = F1.employeeID)
                                else ''
               end AS ADCEID,
               case
                   when exists (SELECT F1.* FROM #Firsttry F1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = F1.Userid) then
                                (SELECT Top 1 F1.Userid + '  ' + F1.AState FROM #Firsttry F1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = F1.Userid)
                   else ''
               end AS ADCEUN,
               case
                   when exists (SELECT F1.* FROM #Firsttry F1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = F1.sAMAccountName) then
                                (SELECT Top 1 F1.sAMAccountName + '  ' + F1.AState FROM #Firsttry F1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = F1.sAMAccountName)
                   else ''
               end AS ADsAMUN,
               case
                   when exists (SELECT SP1.* FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE ST1.StudentUID = SP1.StudentUID) then
                               (SELECT SP1.PortalHandle FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE ST1.StudentUID = SP1.StudentUID)
                   else ''
               end AS SPHandle,
               case
                   when exists (SELECT SP1.* FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE ST1.StudentUID = SP1.StudentUID) then
                               (SELECT SP1.PortalPassword FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE ST1.StudentUID = SP1.StudentUID)
                   else ''
               end AS SPPword, 
              case
                   when exists (SELECT SP1.* FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = SP1.PortalHandle) then
                               (SELECT TOP 1 SP1.PortalHandle FROM CAMS_Enterprise.dbo.StudentPortal SP1 WHERE LTRIM(RTRIM(ST1.LastName)) + SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) = SP1.PortalHandle)
                   else ''
               end AS SPUserID,                
               case  
                   when exists (SELECT Top 1 ADA1.* FROM Trocaire_Extra.dbo.ADADInfo ADA1 WHERE ST1.StudentUID = ADA1.StudentUID) then
                               (SELECT Top 1 ADA1.USERID FROM Trocaire_Extra.dbo.ADADInfo ADA1 WHERE ST1.StudentUID = ADA1.StudentUID) 
                   else ''
               end AS ADADUID,
               case
                   when exists (SELECT #Dub.* FROM #Dub WHERE ST1.StudentID = #Dub.employeeID) then 'Double' else 'Single'
               end AS DS,
               case
                   when exists (SELECT UP.* FROM Trocaire_Extra.dbo.UPGen UP WHERE ST1.StudentUID = UP.StudentUID) then
                               (SELECT UP.Password FROM Trocaire_Extra.dbo.UPGen UP WHERE ST1.StudentUID = UP.StudentUID)
                   else ''
               end AS UPW                                                                    
INTO #AllStudents
FROM CAMS_Enterprise.dbo.SRAcademic SR1
LEFT OUTER JOIN CAMS_Enterprise.dbo.TermCalendar TC1
       ON (SR1.TermCalendarID = TC1.TermCalendarID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Glossary GL1
       ON (SR1.CategoryID = GL1.UniqueId)
LEFT OUTER JOIN CAMS_Enterprise.dbo.Student ST1
       ON (SR1.StudentUID = ST1.StudentUID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentStatus SS1
       ON ((SR1.StudentUID = SS1.StudentUID) AND 
           (SR1.TermCalendarID = SS1.TermCalendarID))
LEFT OUTER JOIN CAMS_Enterprise.dbo.StudentProgram SP1
       ON (SS1.StudentStatusID = SP1.StudentStatusID)
LEFT OUTER JOIN CAMS_Enterprise.dbo.MajorMinor MM1
       ON (SP1.MajorProgramID = MM1.MajorMinorID)
WHERE TC1.TextTerm in (@TermParam) AND NOT (GL1.DisplayText = 'Transfer') 
      AND NOT (ST1.LastName = 'Testperson')
      -- AND SP1.SequenceNo = 0 AND ST1.UserDefinedFieldID = 2192 /*Early Admission */
      /* To create accounts for individuals like Lancaster students comment out the line above (starting with AND SP1.SequenceNo...) and add the line below*/
      /* with appropriate StudentIDs*/
      /*AND ST1.StudentID IN ('A0000025022', 'A0000025021', 'A0000023996')*/
ORDER BY   LTRIM(RTRIM(ST1.LastName)), LTRIM(RTRIM(ST1.FirstName))

/*SELECT *
FROM #AllStudents     
*/      
      
SELECT *,
       CAST(SUBSTRING(NUMGEN1, 1, 2) AS INT) AS C1,
       CAST(SUBSTRING(NUMGEN1, 3, 2) AS INT) AS C2,
       CAST(SUBSTRING(NUMGEN1, 5, 2) AS INT) AS C3,
       CAST(SUBSTRING(NUMGEN1, 7, 2) AS INT) AS C4,
       CAST(SUBSTRING(NUMGEN1, 9, 2) AS INT) AS C5,
       CAST(SUBSTRING(NUMGEN1, 11, 2) AS INT) AS C6,
       CAST(SUBSTRING(NUMGEN1, 13, 2) AS INT) AS C7,
       CAST(SUBSTRING(NUMGEN1, 15, 2) AS INT) AS C8
INTO #Final
FROM #AllStudents
WHERE (ADCEID = '') OR (ADADUID = '') OR (SPPword = PPP)

-- SELECT * FROM #Final 
      
    
INSERT INTO Trocaire_Extra.dbo.ADADInfo


SELECT FL.Term, FL.StudentUID, FL.StudentID, FL.LastName, FL.FirstName, FL.MiddleInitial, 
       FL.DegreeProgram, FL.USERID AS USERID,
       SUBSTRING(@RanString1, C1 + 1, 1) +
       SUBSTRING(@RanString2, C2 + 1, 1) +
       SUBSTRING(@RanString3, C3 + 1, 1) +
       SUBSTRING(@RanString4, C4 + 1, 1) +
       SUBSTRING(@RanString4, C5 + 1, 1) +
       SUBSTRING(@RanString4, C6 + 1, 1) +
       SUBSTRING(@RanString4, C7 + 1, 1) +
       SUBSTRING(@RanString4, C8 + 1, 1) AS Pword, 	@BatchParam AS AType /* New1x used to create FA-16 and SU-16 Accounts on 07_19_16*/
																	/* New1w used to create FA-16 and SU-16 Accounts on 07_12_16*/
																	/* New1v used to create FA-16 and SU-16 Accounts on 07_07_16*/
																	/* New1u used to create FA-16 and SU-16 Accounts on 07_07_16*/
																	/* New1t used to create FA-16 and SU-16 Accounts on 07_07_16*/
																	/* New1s used to create FA-16 and SU-16 Accounts on 06_29_16*/
																	/* New1r used to create FA-16 and SU-16 Accounts on 06_09_16*/
																	/* New1q used to create FA-16 and SU-16 Accounts on 06_09_16*/
																	/* New1p used to create FA-16 and SU-16 Accounts on 06_07_16*/
																	/* New1o used to create FA-16 and SU-16 Accounts on 06_01_16*/
																	/* New1n used to create FA-16 and SU-16 Accounts on 05_24_16*/
																	/* New1m used to create FA-16 and SU-16 Accounts on 05_20_16*/
																	/* New1l used to create SU-16 Accounts on 05_18_16*/
																	 /* New1k used to create FA-16 Accounts on 05_18_16*/
																	/* New1j used to create FA-16 Accounts on 05_09_16*/
																	/* New1i used to create SU-16 Accounts on 05_09_16*/
																	/* New1h used to create FA-16 Accounts on 05_09_16*/
																	/* New1g used to create SU-16 Accounts on 05_02_16*/
																	/* New1f used to create FA-16 Accounts on 05_02_16*/
																	/* New1e used to create SU-16 Accounts on 05_02_16*/
																	/* New1d used to create FA-16 Accounts on 05_02_16*/
																	/* New1c used to create FA-16 Accounts on 04_26_16*/
																    /* New1a used to create SU-16 and FA-16 Accounts on 04_25_16*/
																   /* New1 used to create SU-16 and FA-16 Accounts on 03_22_16*/
																   /* New2 used to create SP-16 Accounts on 11_24_15*/
																   /* New3 used to create SP-16 Accounts on 12_08_15*/	
																   /* New4 used to create SP-16 Accounts on 12_14_15*/
																   /* New5 used to create SP-16 Accounts on 12_22_15*/
																   /* New6 used to create SP-16 Accounts on 01_04_16*/
																   /* New7 used to create SP-16 Accounts on 01_04_16(PM)*/
																   /* New8 used to create SP-16 Accounts on 01_05_16*/
																   /* New9 used to create SP-16 Accounts on 01_08_16*/
																   /* New10 used to create SP-16 Accounts on 01_11_16*/
																   /* New11 used to create SP-16 Accounts on 01_13_16*/
																   /* New12 used to create SP-16 Accounts on 01_14_16*/
																   /* New13 used to create SP-16 Accounts on 01_15_16*/
																   /* New14 used to create SP-16 and early admits Accounts on 01_19_16*/
																   /* New15 used to create SP-16 Accounts on 01_21_16*/
																   /* New16 used to create SP-16 Accounts on 01_22_16 (none)*/
																   /* New16 used to create SP-16 Accounts on 01_25_16*/
																   /* New17 used to create SP-16 Accounts on 01_25_16 (2)*/
																   /* New18 used to create SP-16 Accounts on 01_26_16*/
																   /* New19 used to create SP-16 Accounts for Timon on 01_29_16*/
																   /* New20 used to create FA-15 Lancaster Accounts on 08_04_2015*/
                                                                   /* New21 used to create FA-15 (no BSN)Accounts on 08_10_2015*/
                                                                   /* New22 used to create FA-15 Accounts on 08_13_2015*/
                                                                   /* New23 used to create FA-15 and FA-BSN-15 Accounts on 08_17_2015*/
                                                                   /* New24 used to create FA-15 and Fa-BSN-15 Accounts on 08_18_2015*/
                                                                   /* New25 used to create FA-15 and FA-BSN-15 Accounts on 08_18_2015 PM*/
                                                                   /* New26 used to create FA-15 and FA-BSN-15 Accounts on 08_19_2015*/
                                                                   /* New27 used to create FA-15 and FA-BSN-15 Accounts on 08_20_2015*/
                                                                   /* New28 used to create FA-15 and FA-BSN-15 Accounts on 08_24_2015*/
                                                                   /* New29 used to create FA-15 and FA-BSN-15 Accounts on 08_25_2015*/
                                                                   /* New30 used to create FA-15 and FA-BSN-15 Accounts on 08_26_2015*/
                                                                   /* New31 used to create FA-15 and FA-BSN-15 Accounts on 08_27_2015*/
                                                                   /* New32 used to create FA-15 Early Admits Accounts on 08_27_2015*/
                                                                   /* New33 used to create FA-15 and FA-BSN-15 Accounts (None)on 08_28_2015*/
                                                                   /* New34 used to create FA-15 and FA-BSN-15 Accounts (None)on 08_31_2015*/
                                                                   /* New35 used to create FA-15 and FA-BSN-15 Accounts (None)on 09_01_2015*/
                                                                   /* New36 used to create FA-15 Lanaster (2) student accounts on 9_23_2015*/
                                                                   
FROM #Final FL
WHERE NOT StudentUID IN (62801, 4565, 18640, 5405, 68937, 100241, 61090, 96053, 98774, 9397) 
     AND NOT (StudentUID = 64542 AND DegreeProgram = 'Practical Nursing - Certificate') 
     AND NOT (StudentUID = 106393 AND DegreeProgram = 'General Studies') 
     
/*SELECT *
FROM #Firsttry 
WHERE NOT userid IS NULL AND NOT LastName IS NULL
ORDER BY AState     
*/      
      
DROP TABLE #Firsttry  
DROP TABLE #AllStudents    
DROP TABLE #Dub
DROP TABLE #Final
	
	
	
END


GO


