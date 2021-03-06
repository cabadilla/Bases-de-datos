/****** Object:  StoredProcedure [dbo].[verMovimientosCAdeEstadoCuenta]    Script Date: 7/12/2020 14:59:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verMovimientosCAdeEstadoCuenta]
	@IdEstadoCuenta int
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
		50006,
		SUSER_SNAME(),
		ERROR_NUMBER(),
		ERROR_STATE(),
		ERROR_SEVERITY(),
		ERROR_LINE(),
		ERROR_PROCEDURE(),
		ERROR_MESSAGE(),
		GETDATE()
		);

	END CATCH

SET NOCOUNT OFF
END