
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  		
INTO #Firsttry
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn < ''Caaaaa''
      ORDER BY mailnickname')

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Caaaa''AND sn < ''Eaaaaa''
      ORDER BY mailnickname') 
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Eaaaa''AND sn < ''Gaaaaa''
      ORDER BY mailnickname') 
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Gaaaa''AND sn < ''Kaaaaa''
      ORDER BY mailnickname')      

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Kaaaa''AND sn < ''Maaaaa''
      ORDER BY mailnickname')   

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Maaaa''AND sn < ''Paaaaa''
      ORDER BY mailnickname') 

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Paaaa''AND sn < ''Saaaaa''
      ORDER BY mailnickname')
      
INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Saaaa''AND sn < ''Uaaaaa''
      ORDER BY mailnickname')      

INSERT INTO #Firsttry      
SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Act' AS AState, sAMAccountName, employeeID
,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Students,DC=Trocaire,DC=local''
      WHERE sn > ''Uaaaa''
      ORDER BY mailnickname')

--------


--INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----INTO #Firsttry
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn < ''Caaaaa''
----      ORDER BY mailnickname')
      
----      INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Caaaa''AND sn < ''Gaaaaa''
----      ORDER BY mailnickname')
      
----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----            WHERE sn > ''Gaaaa''AND sn < ''Kaaaaa''
----      ORDER BY mailnickname')
            
----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Kaaaa''AND sn < ''Maaaaa''
----      ORDER BY mailnickname')
 
----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Maaaa''AND sn < ''Paaaaa''
----      ORDER BY mailnickname')      

----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Paaaa''AND sn < ''Saaaaa''
----      ORDER BY mailnickname') 

----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Saaaa''AND sn < ''Uaaaaa''
----      ORDER BY mailnickname')                      

----INSERT INTO #Firsttry
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Stu' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Student Accounts,OU=Students,DC=Trocaire,DC=local''
----      WHERE sn > ''Uaaaa''
----      ORDER BY mailnickname')  


	  select * from #Firsttry

	  drop table #Firsttry