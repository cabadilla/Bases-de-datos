CREATE PROCEDURE verPersona
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
      ,[Nombre]
      ,[IdTipoDcumentoIdentidad]
      ,[FechaNacimiento]
      ,[Email]
      ,[Telefono1]
      ,[Telefono2]
  FROM [dbo].[Persona]
  WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END

