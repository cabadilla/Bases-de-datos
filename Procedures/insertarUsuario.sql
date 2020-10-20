CREATE PROCEDURE [dbo].[insertarUsuario]
    -- Parámetros del SP
    @Usuario nchar(100),
	@Contrasena nchar(100),
	@EsAdministrador int
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		INSERT INTO [dbo].[Usuario]
           ([Usuario]
           ,[Contrasena]
           ,[EsAdministrador])
     VALUES
           (@Usuario
           ,@Contrasena
           ,@EsAdministrador)

	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END