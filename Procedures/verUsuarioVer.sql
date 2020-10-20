CREATE PROCEDURE [dbo].[verUsuarioVer]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [Id]
      ,[IdUsuario]
      ,[NumeroCuenta]
		FROM [dbo].[Usuario_Ver]

		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END