USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep1]    Script Date: 7/20/2017 10:25:13 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep1]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep1]    Script Date: 7/20/2017 10:25:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep1]
	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
	@TermParam varchar(15)

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
      
SELECT DISTINCT dbo.gettermtext(ST1.ExpectedTermID) AS Term,
               ST1.StudentUID, ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName)) AS LastName, LTRIM(RTRIM(ST1.FirstName)) AS FirstName, ST1.MiddleInitial, 
			   --MM1.MajorMinorName AS DegreeProgram,
			    dbo.getCurrentMajorFromUIDByTerm(St1.studentuid, 616) as DegreeProgram,
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
from Student ST1

	
WHERE 
ST1.ExpectedTermID >= (616) 
AND
 ST1.TypeID in (2633,2634)
AND St1.ProspectStatusID in (1,3)

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

delete from dbo.SA_tmpADImporttbl
insert into dbo.SA_tmpADImporttbl
SELECT * FROM #Final 
      
/*    
INSERT INTO Trocaire_Extra.dbo.ADADInfo
*/


     
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


