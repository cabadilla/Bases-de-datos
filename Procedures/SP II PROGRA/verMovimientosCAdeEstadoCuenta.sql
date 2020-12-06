/****** Object:  StoredProcedure [dbo].[verMovimientosCAdeEstadoCuenta]    Script Date: 6/12/2020 01:34:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verMovimientosCAdeEstadoCuenta]
	@IdEstadoCuenta int,
	@codigoError INT OUTPUT
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		

		SELECT 	MCA.Fecha,
				MCA.Descripcion,
				TMCA.Tipo,
				MCA.Monto, 
				MCA.NuevoSaldo
					
		FROM  [dbo].[MovimientoCA] MCA, [dbo].[TipoMovimientoCA] TMCA
		WHERE (MCA.IdEstadoCuenta = @IdEstadoCuenta) and TMCA.Id = MCA.IdTipoMovimientoCA
		ORDER BY Fecha DESC --Se ordenan
		

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50001,
		SUSER_SNAME(),
		ERROR_NUMBER(),
		ERROR_STATE(),
		ERROR_SEVERITY(),
		ERROR_LINE(),
		ERROR_PROCEDURE(),
		ERROR_MESSAGE(),
		GETDATE()
		);
		SET @codigoError=50001

	END CATCH

SET NOCOUNT OFF
END