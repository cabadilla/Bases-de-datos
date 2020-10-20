CREATE PROCEDURE [DBO].[modificarUsuarioVer]

@Id int,
@IdUsuario int,
@NumeroCuenta int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	UPDATE [dbo].[Usuario_Ver]
	SET [IdUsuario] = @IdUsuario
      ,[NumeroCuenta] = @NumeroCuenta
	WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END


