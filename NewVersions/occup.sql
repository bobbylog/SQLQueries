
DECLARE @date DATE = '10/01/2017'

--drop table #TmpTable
--drop table #TmpTable1
--drop table #tmpCalendar1

;WITH N(N)AS 
(SELECT 1 FROM(VALUES(1),(1),(1),(1),(1),(1))M(N)),
tally(N)AS(SELECT ROW_NUMBER()OVER(ORDER BY N.N)FROM N,N a)
SELECT top(day(EOMONTH(@date)))
  N day,
  dateadd(d,N-1, @date) date
into #tmpTable
FROM tally


select *, datename(dw,date) as dname , dbo.getProjectDayOccupancy(date) as Occupancy into #tmptable1 from #tmpTable

--select * from #tmptable1

DECLARE @name1 varchar(25)
DECLARE @name2 varchar(25)
DECLARE @name3 varchar(25)
DECLARE @name4 int

DECLARE @n int
DECLARE @CPass int

set @n=0
set @CPass=1
DECLARE db_cursor1 CURSOR FOR  
			select day, date, dname, isnull(Occupancy,0) from #tmptable1
			
			OPEN db_cursor1   
			FETCH NEXT FROM db_cursor1 INTO @name1, @name2, @name3,@name4

			WHILE @@FETCH_STATUS = 0   
			BEGIN  
				  if @name4>0 and @n=0 set @n=@name4+1

				  

				  if @CPass=1
				     select @name1 as day,@name2 as date,@name3 as dname,@name4 as Occupancy,@n as OccIndex
					 into #tmpTable2
                 
				 if @CPass>1
				     insert into #tmpTable2
				     select @name1 as day,@name2 as date,@name3 as dname,@name4 as Occupancy,@n as OccIndex
					
				
                 if @name4=0  and @n > 0
					set @n=@n-1

					--print @Cpass
				 --  print @n
					 
                 set @Cpass=@CPass+1
				
				

		   
				   FETCH NEXT FROM db_cursor1 INTO  @name1, @name2, @name3,@name4

				 
			END   

			CLOSE db_cursor1  
			DEALLOCATE db_cursor1
			

			select * from #tmpTable2



drop table #TmpTable
drop table #TmpTable1
drop table #TmpTable2
drop table #tmpCalendar1