/****** Script for SelectTopNRows command from SSMS  ******/


SELECT *
  
  FROM [OneCard].[onecard2].[ACCOUNTS]
  Where
  LNAME='HARRIS'
  -- year(added)=2017

drop table #TmpTable

SELECT 
       [ACCOUNT]
	   ,St.StudentUID as CAMSUID
      ,[ADDED]
      ,[CUSTOM]
	  ,St.StudentID as CAMSOFFICIAL
	  ,[LNAME]
      ,[FNAME]
      ,[IDTYPE]
      ,[IDVALUE]
      ,[INACTIVE]
      , dbo.isStudentEnrolled (St.StudentUID, 616) as Enrolled
	  ,dbo.getStudentEmailAddressFromID(St.studentID) as Email1
  into #TmpTable
  FROM [OneCard].[onecard2].[ACCOUNTS] OC
  inner join
  [CAMS_Enterprise].[dbo].[Student] ST
  on OC.ACCOUNT=ST.StudentUID
  
  where year(OC.Added) in (2014,2015,2016,2017) 
  --and month(Oc.added)='08'

  ----select * from student 
  ----where lastname='jordan' and firstname='La tasha'

  ALTER TABLE #TmpTable
  ALTER COLUMN CUSTOM
    VARCHAR(100) COLLATE Latin1_General_CI_AS 

	ALTER TABLE #TmpTable
  ALTER COLUMN CAMSOFFICIAL
    VARCHAR(100) COLLATE Latin1_General_CI_AS 

  
  select * from #TmpTable
  WHERE 
  cast (CUSTOM as varchar) <> cast(CAMSOFFICIAL as varchar)
  and 
  CUSTOM <> ''
  and Enrolled=1
  order by Added desc

  drop table #TmpTable