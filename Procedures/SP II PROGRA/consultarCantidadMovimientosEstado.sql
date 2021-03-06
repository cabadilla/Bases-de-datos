/****** Object:  StoredProcedure [dbo].[ConsultarCantidadMovimientosEstado]    Script Date: 8/12/2020 15:41:06 ******/
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
		DECLARE @IddCuenta INT
		DECLARE @aux INT
		DECLARE @depositosATM INT
		DECLARE @depositosVentana INT 
		DECLARE @retirosATM INT
		DECLARE @retirosVentana INT
		DECLARE @montoInteres INT
		DECLARE @tipoCuenta INT
		DECLARE @table TABLE 
				(intereses INT,
				retirosATM INT,
				retirosVentana INT,
				depositosATM INT,
				depositosVentana INT
				)

		SELECT @IddCuenta = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@IdCuenta

		SELECT @tipoCuenta=C.IdTipoCuentaAhorros
		FROM CuentaAhorros C
		WHERE C.Id=@iddCuenta

		SELECT @montoInteres=T.Intereses
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		SELECT @aux=T.SaldoMinimo
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		--SE SACA EL VALOR AL QUE CORRESPONDEN LOS INTERESES Y SE LE SUMA A LA CUENTA
		SET @aux=(@aux*@montoInteres)/100


		--Se calcula la cantidad de retiros
		SET @retirosATM = (SELECT COUNT(*) 
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and MCA.IdTipoMovimientoCA = 2
		)
		
		SET @retirosVentana = (SELECT COUNT(*) 
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta and MCA.IdTipoMovimientoCA = 3
		)
		
		--Se calcula la cantidad de depositos
		
		SET @depositosATM = (SELECT  COUNT(*)
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta 
			and MCA.IdTipoMovimientoCA = 4
		)
		SET @depositosVentana = (SELECT  COUNT(*)
		FROM MovimientoCA MCA
		WHERE MCA.IdEstadoCuenta=@IdEstadoCuenta 
			and MCA.IdTipoMovimientoCA= 5 
		)
		
		INSERT INTO @table (intereses,retirosATM,retirosVentana,depositosATM,depositosVentana)
		SELECT @aux,@retirosATM,@retirosVentana,@depositosATM,@depositosVentana
		SELECT * FROM @table
		
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50009,
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
