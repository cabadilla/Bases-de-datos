SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[borrarEstadoCuenta]

@Id int

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DELETE FROM [dbo].[EstadoCuenta]
      WHERE Id=@Id

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END