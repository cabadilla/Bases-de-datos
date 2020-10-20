CREATE PROCEDURE [dbo].[modificarUsuario]
    -- Parámetros del SP
@Id int,
@Usuario nchar(100),
@Contrasena nchar(100),
@EsAdministrador int
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		UPDATE [dbo].[Usuario]
   SET [Usuario] = @Usuario
      ,[Contrasena] = @Contrasena
      ,[EsAdministrador] = @EsAdministrador
 WHERE Id=@Id

	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END