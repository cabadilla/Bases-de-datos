CREATE PROCEDURE [DBO].[borrarCuentaAhorro]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DELETE FROM [dbo].[CuentaAhorros]
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END

