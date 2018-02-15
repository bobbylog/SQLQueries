SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Sta' AS AType, 'Act' AS AState, sAMAccountName, employeeID,
CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  
INTO #Firsttry
FROM OPENQUERY( ADSI01, 
     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
      FROM ''LDAP://OU=Users,OU=Staff,DC=Trocaire,DC=local''')
      


--INSERT INTO #Firsttry      
----SELECT  TOP 999 Mailnickname [Userid], sn [LastName], givenname[FirstName], 'Sta' AS AType, 'Dis' AS AState, sAMAccountName, employeeID,
----CAST((cast(LastLogonTimeStamp as numeric(25,2)) / 864000000000.0 - 109207) AS DATETIME)  as LastLogon, 
----CAST( case when (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) < 0 then 0 else (cast(PwdLastSet as numeric(25,2)) / 864000000000.0 - 109207) end  AS DATETIME)  as PassLastSet  

----INTO #Firsttry 
----FROM OPENQUERY( ADSI01, 
----     'SELECT mailnickname, sn, givenname, sAMAccountName, employeeID,LastLogonTimeStamp, PwdLastSet
----      FROM ''LDAP://OU=Disabled Staff Accounts,OU=Staff,DC=Trocaire,DC=local''')


	  select * from #Firsttry

	  drop table #Firsttry