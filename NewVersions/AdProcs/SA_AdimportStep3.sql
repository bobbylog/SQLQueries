USE [CAMS_Enterprise]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep3]    Script Date: 7/20/2017 11:07:36 AM ******/
DROP PROCEDURE [dbo].[SA_AdimportStep3]
GO

/****** Object:  StoredProcedure [dbo].[SA_AdimportStep3]    Script Date: 7/20/2017 11:07:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SA_AdimportStep3]
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


-- delete FROM Trocaire_Extra.dbo.ADADInfo where Term='sp-17' and AType='New172' and StudentID='A0000026468' and DegreeProgram like 'General Studies%'
--				 SELECT * FROM Trocaire_Extra.dbo.ADADInfo AD 
--                      WHERE AD.Term IN ('sp-17') AND AD.AType = 'New172'
--order by ad.LastName asc

SELECT DISTINCT dbo.gettermtext(ST1.ExpectedTermID) AS Term,
               ST1.StudentUID, ST1.StudentID, 
               LTRIM(RTRIM(ST1.LastName))AS LName, 
               LTRIM(RTRIM(ST1.FirstName)) AS FName, 
               LTRIM(RTRIM(ST1.MiddleInitial)) AS MInitial,
               SUBSTRING(LTRIM(RTRIM(ST1.LastName)), 1, 1) AS LI,
               SUBSTRING(LTRIM(RTRIM(ST1.FirstName)), 1, 1) AS FI, 
               SUBSTRING(LTRIM(RTRIM(ST1.MiddleInitial)), 1, 1) AS MI,
               dbo.getCurrentMajorFromUIDByTerm(St1.studentuid, 616) as DegreeProgram,
               /*ST1.LastName + SUBSTRING(ST1.FirstName, 1, 1) AS USERID*/
               (SELECT AD1.USERID FROM Trocaire_Extra.dbo.ADADInfo AD1 
                WHERE AD1.StudentUID = ST1.StudentUID AND 
                AD1.Term IN (@TermParam) AND AD1.AType = @BatchParam
                -- AND not (ad1.studentid='A0000026468' and ad1.DegreeProgram like 'general studies%')
                ) AS USERID
INTO #NewS

from Student ST1

	
WHERE 
ST1.ExpectedTermID >= (616) 
AND
 ST1.TypeID in (2633,2634)
AND St1.ProspectStatusID in (1,3)
    AND EXISTS (SELECT * FROM Trocaire_Extra.dbo.ADADInfo AD 
                      WHERE AD.StudentUID = ST1.StudentUID AND  AD.Term IN (@TermParam) AND AD.AType = @BatchParam
                      --AND not (ad.studentid='A0000026468' and ad.DegreeProgram like 'general studies%')
                      )                     
ORDER BY LTRIM(RTRIM(ST1.LastName)), LTRIM(RTRIM(ST1.FirstName)), LTRIM(RTRIM(ST1.MiddleInitial))




SELECT 
--distinct 
NS.USERID AS SID, AD8.Password
INTO #pass
FROM #NewS NS
LEFT OUTER JOIN 
                      --(select * from Trocaire_Extra.dbo.ADADInfo
                     -- where not (term='sp-17' and studentid='A0000026468' and DegreeProgram like 'general studies%')) AD8
                      
Trocaire_Extra.dbo.ADADInfo AD8 


            ON (AD8.StudentUID = NS.StudentUID) AND (AD8.Term IN (@TermParam)) AND AD8.AType = @BatchParam
ORDER BY NS.USERID

DROP TABLE dbo.SA_tmpADFinalAdImport
SELECT USERID AS sAMAccountName,
       LName AS sn,
       FName AS givenName,
       MI AS initials,
       case
          when MI = '' OR MI IS NULL
           then LName + ', ' + FName
          else LName + ', ' + FName + ' ' + MI + '.'
       end AS displayName,
       case
            when DegreeProgram = '' then 'No Program Indicated - ' + Term       
            else DegreeProgram +  ' - ' + Term
       end AS description,
       'CN=Student Accounts,OU=Groups,OU=Students,DC=Trocaire,DC=local;CN=TC All Students Mail,OU=Distribution Lists,OU=Students,DC=Trocaire,DC=local' AS memberOf,
       (SELECT Password
          FROM #pass 
          WHERE #pass.SID = USERID) AS password,
        'TRUE' AS mailboxEnabled,
        USERID + '@trocaire.local' AS userPrincipalName,
        USERID AS mailNickname,
        USERID + '@Trocaire.edu' AS mail,
        'normal.bat' AS scriptPath,
        'SMTP:%username%@trocaire.edu' AS proxyAddresses,
        'TRUE' AS passwordNeverExpires,
        '12/31/2022' AS expires,
        '\\trocaire-FP01\studenthome$\%username%;h:' AS homeFolder,
       case
         when LI in ('A', 'B')
          then 'Student A-B'
         when LI in ('C', 'D')
          then 'Student C-D'
         when LI in ('E', 'F')
          then 'Student E-F'
         when LI in ('G', 'H')
          then 'Student G-H'
         when LI in ('I', 'J', 'K')
          then 'Student I-K'
         when LI in ('L', 'M')
          then 'Student L-M'
         when LI in ('N', 'O', 'P')
          then 'Student N-P'
         when LI in ('Q', 'R', 'S')
          then 'Student Q-S'
         when LI in ('T', 'U', 'V')
          then 'Student T-V'
         when LI in ('W', 'X', 'Y', 'Z')
          then 'Student W-Z'
         else ''
       end AS ExchangeStore,
       StudentID AS employeeID
 INTO dbo.SA_tmpADFinalAdImport    
 FROM #NewS
 
 DROP TABLE dbo.SA_tmpADFinalPasswordFile  
 SELECT SID AS USERID, Password
 INTO dbo.SA_tmpADFinalPasswordFile    
 FROM #pass
 


DROP TABLE #pass
DROP TABLE #NewS

	
END


GO


