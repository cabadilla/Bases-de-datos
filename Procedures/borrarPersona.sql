CREATE PROCEDURE borrarPersona

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DELETE FROM [dbo].[Persona]
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END

