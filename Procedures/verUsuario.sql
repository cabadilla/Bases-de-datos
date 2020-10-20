CREATE PROCEDURE [dbo].[verUsuario]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [Id]
		,[Usuario]
		,[Contrasena]
		,[EsAdministrador]
	FROM [dbo].[Usuario]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END