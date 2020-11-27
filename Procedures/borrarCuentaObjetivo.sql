/****** Object:  StoredProcedure [dbo].[borrarCuentaObjetivo]    Script Date: 27/11/2020 12:31:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarCuentaObjetivo]

@CuentaAhorro int,
@Objetivo nchar(100)

AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
	
	DECLARE @IdCuentaAhorro int
	SELECT @IdCuentaAhorro = CA.Id
	FROM DBO.CuentaAhorros CA
	WHERE CA.NumeroCuenta = @CuentaAhorro

	UPDATE [dbo].[CuentaObjetivo]

	   SET  [isActivo] = 0
	   WHERE (IdCuentaAhorro=@IdCuentaAhorro) and (Objetivo=@Objetivo)
      
	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END
