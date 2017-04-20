drop table #tmpRes
SELECT
  *

FROM
  OPENROWSET(
    'SQLOLEDB',
    'Server=trocaire-sql01;Trusted_Connection=yes;',
	' Exec  CAMS_ENterprise.dbo.TCC_Faculty_Activity_CPR'
)

