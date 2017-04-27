SELECT *
FROM sys.tables
WHERE create_date >= '20160301' AND create_date < '20170531' 

SELECT *
FROM sys.views
WHERE create_date >= '20160301' AND create_date < '20170531' 
