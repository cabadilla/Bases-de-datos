/****** Object:  StoredProcedure [dbo].[ConsultarCantidadMovimientosEstado]    Script Date: 7/12/2020 14:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ConsultarCantidadMovimientosEstado]
	
	@IdEstadoCuenta int,					
	@IdCuenta int

	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		DECLARE @aux INT
		DECLARE @depositos INT
		DECLARE @retiros INT
		DECLARE @montoInteres INT
		DECLARE @tipoCuenta INT
		DECLARE @table TABLE 
				(intereses INT,
				retiros INT,
				depositos INT
				)

		SELECT @tipoCuenta=C.IdTipoCuentaAhorros
		FROM CuentaAhorros C
		WHERE C.Id=@idCuenta

		SELECT @montoInteres=T.Intereses
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		SELECT @aux=T.SaldoMinimo
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		--SE SACA EL VALOR AL QUE CORRESPONDEN LOS INTERESES Y SE LE SUMA A LA CUENTA
		SET @aux=(@aux*@montoInteres)/100

		--Se calcula la cantidad de retiros
		SET @retiros = (SELECT COUNT(TCA.Tipo) AS 'retiros'
		FROM MovimientoCA MCA, TipoMovimientoCA TCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and (MCA.IdTipoMovimientoCA = 2 OR MCA.IdTipoMovimientoCA = 3))
		
		--Se calcula la cantidad de depositos
		SET @depositos = (SELECT  COUNT(TCA.Tipo) AS 'depositos'
		FROM MovimientoCA MCA, TipoMovimientoCA TCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and (MCA.IdTipoMovimientoCA= 5 OR  MCA.IdTipoMovimientoCA = 4)
		)
		INSERT INTO @table (intereses,retiros,depositos)
		SELECT @aux,@retiros,@depositos
		SELECT * FROM @table

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50002,
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