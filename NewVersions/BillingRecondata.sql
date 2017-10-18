select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000025344')
and Amount=365.69
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000026627')
and Amount=496.75
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027577')
and Amount=910.75
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=257.94
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027428')
and Amount=36.26
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=197.6
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=520.1
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=16.74
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=59.35
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=5.61
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=543.68
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=40.86
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=24.32
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=35.6
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=41.86
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000024018')
and Amount=113.15
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000026627')
and Amount=21.38
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=15.72
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=3.02
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=43.82
---------new 
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000026351')
and Amount=1267.14
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027534')
and Amount=88
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000020467')
and Amount=1261.46
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=579.45
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000026627')
and Amount=32.73
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027577')
and Amount=75.23
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=1.84
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=7.89
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=27.55
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027739')
and Amount=55.1
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027666')
and Amount=65.95
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000014115')
and Amount=166.65
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000027714')
and Amount=303.25
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A0000025375')
and Amount=21.62
union
select * from Billing
where OwnerUID=dbo.getStudentUIDfromID('A00000276627')
and Amount=19.05
--select * from Billing
--where 
---- OwnerUID=dbo.getStudentUIDfromID('A0000025344')
--month(TransDate)=09 and day(transdate)=12 and year(transdate)='2017'
--and Description='BookStore Charges (BNA)'
---- Amount=365.69
