CREATE PROCEDURE [DBO].[borrarCuentaObjetivo]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DELETE FROM [dbo].[CuentaObjetivo]
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END