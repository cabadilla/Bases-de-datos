/****** Object:  StoredProcedure [dbo].[modificarCuentaObjetivo]    Script Date: 29/11/2020 13:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarCuentaObjetivo]

@ObjetivoNuevo nchar(100),
@ObjetivoViejo nchar(100),
@numeroCuenta int
AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY
		
		DECLARE @IdNumeroCuenta int 
		SELECT @IdNumeroCuenta = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@numeroCuenta

		UPDATE [dbo].[CuentaObjetivo]
	    SET [Objetivo] = @ObjetivoNuevo
		WHERE Objetivo = @ObjetivoViejo and IdCuentaAhorro=@IdNumeroCuenta
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END
