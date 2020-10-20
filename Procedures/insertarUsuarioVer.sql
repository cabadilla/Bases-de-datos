CREATE PROCEDURE [DBO].[insertarUsuarioVer]

@IdUsuario int,
@NumeroCuenta int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	INSERT INTO [dbo].[Usuario_Ver]
           ([IdUsuario]
           ,[NumeroCuenta])
     VALUES
           (@IdUsuario
           ,@NumeroCuenta)

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END


