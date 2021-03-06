/****** Object:  StoredProcedure [dbo].[hacerCierre]    Script Date: 7/12/2020 14:48:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[hacerCierre]
    -- Parámetros del SP
@idEstado int,
@fecha date


AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  
		DECLARE @idCuenta int
		DECLARE @montoInteres INT
		DECLARE @montoMultas int
		DECLARE @cantidadDeVeces int
		DECLARE @aux int
		DECLARE @saldoCuenta int
		DECLARE @tipoCuenta int
		-----SE SACA EL ID DE LA CUENTA DE AHORROS
		SELECT @idCuenta= C.IdCuentaAhorro
		FROM EstadoCuenta C
		WHERE C.Id=@idEstado

		----EN ESTA SECCION SE VAN A CALCULAR EL INTERES MENSUAL
		SELECT @tipoCuenta=C.IdTipoCuentaAhorros
		FROM CuentaAhorros C
		WHERE C.Id=@idCuenta

		SELECT @montoInteres=T.Intereses
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		SELECT @aux=T.SaldoMinimo
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta
		----se saca el monto de los intereses y se le envia a aux
		SET @aux=(@aux*@montoInteres)/100
		---se encuentra el nuevo monto de la cuenta de ahorro
		SELECT @saldoCuenta=C.Saldo
		FROM CuentaAhorros C
		WHERE C.Id=@idCuenta

		----SE LE CAMBIA EL VALOR AL SALDO
		SET @saldoCuenta=@aux+@saldoCuenta
		---se inserta crea el movimiento
		INSERT INTO [dbo].[MovimientoCA]
           ([Descripcion]
           ,[Fecha]
           ,[Monto]
           ,[NuevoSaldo]
           ,[IdTipoMovimientoCA]
           ,[IdCuentaAhorros]
           ,[IdEstadoCuenta])
     VALUES
           ('Interes',
           @fecha,
           @aux,
           @saldoCuenta,
           7,
           @idCuenta,
           @idEstado)


		----SE ACTUALIZA EL SALDO DE LA CUENTA

			UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = @saldoCuenta
		 WHERE Id=@idCuenta


		-----FIN INTERES MENSUAL

		----SE CALCULAN LAS MULTAS POR CAJERO AUTOMATICO

		SELECT @cantidadDeVeces=COUNT(M.Id)
		FROM MovimientoCA M
		WHERE M.IdTipoMovimientoCA=2

		SELECT @aux=T.NumRetirosAutomatico
		FROM TipoCuentaAhorros T
		WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

		IF	@cantidadDeVeces>@aux
			BEGIN
				SELECT @montoMultas=T.ComisionAutomatico
				FROM TipoCuentaAhorros T
				WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

				SET @montoMultas=(@cantidadDeVeces-@aux)*@montoMultas
				SET @saldoCuenta=@saldoCuenta-@montoMultas

				INSERT INTO [dbo].[MovimientoCA]
					   ([Descripcion]
					   ,[Fecha]
					   ,[Monto]
					   ,[NuevoSaldo]
					   ,[IdTipoMovimientoCA]
					   ,[IdCuentaAhorros]
					   ,[IdEstadoCuenta])
				 VALUES
					   ('Multa por exeso de retiros en cajero automatico',
					   @fecha,
					   @montoMultas,
					   @saldoCuenta,
					   1,
					   @idCuenta,
					   @idEstado)
				----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
					UPDATE [dbo].[CuentaAhorros]
						SET
						  Saldo = @saldoCuenta
					 WHERE Id=@idCuenta

			END

		

		----FIN DE LAS MULTAS POR CAJERO
		----MULTAS POR VENTANILLA

		SELECT @cantidadDeVeces=COUNT(M.Id)
		FROM MovimientoCA M
		WHERE M.IdTipoMovimientoCA=3

		SELECT @aux=T.NumRetirosHumano
		FROM TipoCuentaAhorros T
		WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

		IF	@cantidadDeVeces>@aux
			BEGIN
				SELECT @montoMultas=T.ComisionHumano
				FROM TipoCuentaAhorros T
				WHERE T.Id=(SELECT C.IdTipoCuentaAhorros FROM CuentaAhorros C WHERE C.Id=@idCuenta)

				SET @montoMultas=(@cantidadDeVeces-@aux)*@montoMultas
				SET @saldoCuenta=@saldoCuenta-@montoMultas

				INSERT INTO [dbo].[MovimientoCA]
					   ([Descripcion]
					   ,[Fecha]
					   ,[Monto]
					   ,[NuevoSaldo]
					   ,[IdTipoMovimientoCA]
					   ,[IdCuentaAhorros]
					   ,[IdEstadoCuenta])
				 VALUES
					   ('Multa por exeso de retiros en ventanilla',
					   @fecha,
					   @montoMultas,
					   @saldoCuenta,
					   1,
					   @idCuenta,
					   @idEstado)
				----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
					UPDATE [dbo].[CuentaAhorros]
						SET
						  Saldo = @saldoCuenta
					 WHERE Id=@idCuenta

			END


		---FIN MULTAS POR VENTANILLA



		----SE REBAJA EL CARGO MENSUAL

		---SE ENCUENTRA EL VALOR DEL CARGO MENSUAL
		SELECT @aux=T.CargoAnual
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta

		---se le cambia el valor al saldo
		SET @saldoCuenta=@saldoCuenta-@aux

	----SE CREA EL MOVIMIENTO
	INSERT INTO [dbo].[MovimientoCA]
           ([Descripcion]
           ,[Fecha]
           ,[Monto]
           ,[NuevoSaldo]
           ,[IdTipoMovimientoCA]
           ,[IdCuentaAhorros]
           ,[IdEstadoCuenta])
     VALUES
           ('Cargo mensual',
           @fecha,
           @aux,
           @saldoCuenta,
           1,
           @idCuenta,
           @idEstado)
	----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
		UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = @saldoCuenta
		 WHERE Id=@idCuenta

	----SE  CALCULA LA MULTA POR SALDO MINIMO

	SELECT @aux=T.SaldoMinimo
	FROM TipoCuentaAhorros T
	WHERE T.Id=@tipoCuenta

	---DESPUES DE ENCONTRAR EL VALOR DEL SALDO MIN Y DEL SALDO DE LA CUENTA SE REALIZA UN IF PARA VERIFICAR SI SE LE DEBE DE REBAJAR
	IF @saldoCuenta<@aux
		BEGIN
			---se inserta el movimiento
			SELECT @aux= MultaSaldoMin 
			FROM TipoCuentaAhorros 
			WHERE Id=(SELECT IdTipoCuentaAhorros FROM CuentaAhorros WHERE Id=@idCuenta)

			SET @saldoCuenta=@saldoCuenta-@aux

			INSERT INTO [dbo].[MovimientoCA]
           ([Descripcion]
           ,[Fecha]
           ,[Monto]
           ,[NuevoSaldo]
           ,[IdTipoMovimientoCA]
           ,[IdCuentaAhorros]
           ,[IdEstadoCuenta])
		 VALUES
			   ('saldo minimo',
			   @fecha,
			   @aux,
			   @saldoCuenta,
			   1,
			   @idCuenta,
			   @idEstado)


			UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = @saldoCuenta
			WHERE Id=@idCuenta
		END
		
		----SE GENERA EL NUEVO ESTADO DE CUENTA
	SELECT @aux= Saldo 
	FROM CuentaAhorros 
	WHERE Id=@idCuenta
		UPDATE [dbo].[EstadoCuenta]
		SET
		  [SaldoFinal] = @aux
	 WHERE Id=@idEstado
	 ---la nueva fecha de inicio va a ser la fecha final del anterior mas un dia
	DECLARE @fechaInicio date
	SELECT @fechaInicio=E.FechaFinal
	FROM EstadoCuenta E
	WHERE E.Id=@idEstado
	SET @fechaInicio=DATEADD(DAY, 1, @fechaInicio)

	----se calcula la fecha final
	DECLARE @fechaFinal DATETIME;
	SET @fechaFinal = DATEADD(MONTH, 1, @fechainicio);
	SET @fechaFinal = DATEADD(DAY, -1, @fechaFinal);

	--toma el saldoInicial de lo que acaba de insertar de la tabla inserted


	INSERT INTO EstadoCuenta(
				[IdCuentaAhorro],
				[FechaInicio],
				[FechaFinal],
				[SaldoInicial])
		VALUES (@idCuenta,@Fechainicio,@FechaFinal,@aux)

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
	END CATCH
SET NOCOUNT OFF
END