create table #temptable(
	tuid varchar(25)
)
Insert into #temptable(tuid) VALUES('110366')
Insert into #temptable(tuid) VALUES('72951')
Insert into #temptable(tuid) VALUES('61212')
Insert into #temptable(tuid) VALUES('1988')
Insert into #temptable(tuid) VALUES('1540')
Insert into #temptable(tuid) VALUES('82749')
Insert into #temptable(tuid) VALUES('88322')
Insert into #temptable(tuid) VALUES('82749')
Insert into #temptable(tuid) VALUES('74789')
Insert into #temptable(tuid) VALUES('1988')
Insert into #temptable(tuid) VALUES('55189')
Insert into #temptable(tuid) VALUES('57116')
Insert into #temptable(tuid) VALUES('57264')
Insert into #temptable(tuid) VALUES('57020')
Insert into #temptable(tuid) VALUES('54131')
Insert into #temptable(tuid) VALUES('1988')
Insert into #temptable(tuid) VALUES('13399')
Insert into #temptable(tuid) VALUES('47460')
Insert into #temptable(tuid) VALUES('56111')
Insert into #temptable(tuid) VALUES('56262')
/*
Getting a list of id from a list of UID

Building query to insert uid into temporary table

example lines
=CONCATENATE("Insert into #temptable(tuid) VALUES('", A1,"')")
72951	Insert into #temptable(tuid) VALUES('72951')

and then copy the query lines into SQL

*/
Insert into #temptable(tuid) VALUES('61626')
Insert into #temptable(tuid) VALUES('52744')

select tuid, dbo.getstudentidFromUID(tuid) from #temptable


drop table #temptable
