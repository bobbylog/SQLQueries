declare @AccCh varchar(max)
declare @UroleID int

set @UroleID=32
SELECT @AccCh=txtMenuAccess From CAMS_UserRoles_View
where CAMSUserRolesID=@UroleID

exec dbo.DecryptAccessChain @AccCh, @UroleID

