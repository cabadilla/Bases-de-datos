SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verMovimientosCAdeEstadoCuenta]
	@IdEstadoCuenta int
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		

		SELECT 	MCA.Fecha,
				MCA.Descripcion,
				MCA.Monto, 
				MCA.NuevoSaldo
					
		FROM  [dbo].[MovimientoCA] MCA
		WHERE (MCA.IdEstadoCuenta = @IdEstadoCuenta) 
		ORDER BY Fecha DESC --Se ordenan

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END


SELECT * FROM EstadoCuenta
SELECT * FROM MovimientoCA
SELECT * FROM TipoMovimientoCA