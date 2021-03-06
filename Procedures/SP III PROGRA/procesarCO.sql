/****** Object:  StoredProcedure [dbo].[procesarCO]    Script Date: 22/12/2020 13:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[procesarCO]
----se procesan los intereses diarios
	@dia DATE
	AS
	BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @contadorAux int
		DECLARE @iteradorAux int
		DECLARE @idCuenta int
		DECLARE @cuota float
		DECLARE @idCuentaAhorro int
		DECLARE @saldo float
		DECLARE @montoIntereses float

		----en este segmento del codigo primero se va a sumar a la cuenta objetivo el monto mensual en caso de ser el dia correspondiente
		----mientras que a la cuenta de ahorros se le va a rebajar
		SELECT @contadorAux=COUNT(C.Id)
		FROM CuentaObjetivo C
		WHERE C.DiasRebajo=DAY(@dia)

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM DBO.CuentaObjetivo C
				WHERE (C.Id > @idCuenta) AND (C.DiasRebajo=DAY(@dia))

				SELECT @saldo=C.Saldo,@cuota=V.Cuota
				FROM DBO.CuentaObjetivo V 
				INNER JOIN DBO.CuentaAhorros C ON C.Id=V.IdCuentaAhorro
				WHERE V.Id=@idCuenta

				IF(@saldo-@cuota)>=0
					BEGIN 
						SELECT @idCuentaAhorro=C.IdCuentaAhorro FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta
						---primero se actualiza la cuenta de ahorros y se genera  el movimiento
						BEGIN TRY
							BEGIN TRAN
								UPDATE DBO.CuentaAhorros
								SET Saldo= Saldo-@cuota
								WHERE Id=@idCuentaAhorro

								INSERT INTO DBO.MovimientoCA(
									[Monto]
									,[Fecha]
									,[NuevoSaldo]
									,[IdTipoMovimientoCA]
									,[IdCuentaAhorros]
									,[IdEstadoCuenta]
									,[Descripcion]
									)
								VALUES(
									@cuota,
									@dia,
									(@saldo-@cuota),
									3,
									@idCuentaAhorro,
									(SELECT MAX(E.Id) FROM DBO.EstadoCuenta E WHERE E.IdCuentaAhorro=@idCuentaAhorro),
									'Debito por cuenta objetivo'
								)
							
						---Depues de actualizar la cuenta de ahorros, se le suma a la cuenta objetivo el monto que corresponde y se 
						---inserta el movimiento
								UPDATE DBO.CuentaObjetivo
								SET 
									Saldo=Saldo+@cuota,
									depositos=depositos+1
								WHERE Id=@idCuenta

								INSERT INTO DBO.MovimientoCO(
									IdTipoMovimientoCo,
									Fecha,
									Monto,
									Descripcion,
									IdCuentaObjetivo,
									NuevoSaldo)
								VALUES(
									1,
									@dia,
									@cuota,
									'Deposito mesual',
									@idCuenta,
									(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta)
									)
							COMMIT
						END TRY
						BEGIN CATCH 
							ROLLBACK
							INSERT INTO [dbo].[Errores] VALUES(
							50021,
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
					
					END
					ELSE
						BEGIN
							UPDATE DBO.CuentaObjetivo
							SET depositosNoRealizados=depositosNoRealizados+1
							WHERE Id=@idCuenta
						END 
			
				SET @iteradorAux=@iteradorAux+1
			END

		----en este segundo segmento se van a cerrar las cuentas las cuales se terminan en la fecha de proceso
		SELECT @contadorAux=COUNT(C.Id)
		FROM CuentaObjetivo C
		WHERE C.FechaFin=@dia

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM DBO.CuentaObjetivo C
				WHERE (C.Id > @idCuenta) AND (C.FechaFin=@dia)
				
				SELECT @montoIntereses=V.InteresesAcumulados,@idCuentaAhorro=C.Id
				FROM DBO.CuentaObjetivo V 
				INNER JOIN DBO.CuentaAhorros C ON C.Id=V.IdCuentaAhorro
				WHERE V.Id=@idCuenta

				print(@idCuentaAhorro)

				BEGIN TRY
					BEGIN TRAN
					---En la primera parte de la transaccions e actualiza el saldo  de la cuenta objetivo y quedan los intereses acumulados en cero
						INSERT DBO.movimientosInteresCO(
							IdTipoMovimientoCoInte,
							IdCuentaObjetivo,
							Fecha,
							Monto,
							Descripcion,
							NuevoInteresesAcomulados)
						VALUES(
						1,
						@idCuenta,
						@dia,
						@montoIntereses,
						'Redencion de intereses',
						0)
						---despues de crear el movimiento de intereses, se procede a actualizar la cuenta objetivo
						UPDATE DBO.CuentaObjetivo
						SET 
							Saldo=Saldo+@montoIntereses,
							InteresesAcumulados=0
						WHERE Id=@idCuenta
					---se genera el movimiento
						INSERT MovimientoCO(
							IdTipoMovimientoCo,
							Fecha,
							Monto,
							Descripcion,
							IdCuentaObjetivo,
							NuevoSaldo)
						VALUES(
						2,
						@dia,
						@montoIntereses,
						'Redencion de intereses acumulados',
						@idCuenta,
						(SELECT C.Saldo FROM CuentaObjetivo C WHERE C.Id=@idCuenta))
						---en esta parte se redime el dinero de la cuenta objetivo a la cuenta de ahorro
						UPDATE DBO.CuentaAhorros
						SET 
							Saldo=Saldo+(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta)
						WHERE Id=@idCuentaAhorro

						INSERT INTO DBO.MovimientoCA(
									[Monto]
								   ,[Fecha]
								   ,[NuevoSaldo]
								   ,[IdTipoMovimientoCA]
								   ,[IdCuentaAhorros]
								   ,[IdEstadoCuenta]
								   ,[Descripcion]
								   )
								VALUES(
									(SELECT C.Saldo FROM DBO.CuentaObjetivo C WHERE C.Id=@idCuenta),
									@dia,
									(SELECT C.Saldo FROM DBO.CuentaAhorros C WHERE C.Id=@idCuentaAhorro),
									5,
									@idCuentaAhorro,
									(SELECT MAX(E.Id) FROM DBO.EstadoCuenta E WHERE E.IdCuentaAhorro=@idCuentaAhorro),
									'redencion CO')
					----se crea el movimiento de la cuenta objetico
						INSERT INTO MovimientoCO(
								IdTipoMovimientoCo,
								Fecha,
								Monto,
								Descripcion,
								IdCuentaObjetivo,
								NuevoSaldo)
							VALUES(
							3,
							@dia,
							(SELECT C.Saldo FROM CuentaObjetivo C WHERE C.Id=@idCuenta),
							'Redencion CO',
							@idCuenta,
							0)
						--- desactiva la cuenta objetivo y se pone el saldo en 0
						UPDATE DBO.CuentaObjetivo
						SET 
							Saldo=0,
							isActivo=0
						WHERE Id=@idCuenta
					COMMIT 
				END TRY
				BEGIN CATCH
					ROLLBACK
					INSERT INTO [dbo].[Errores] VALUES(
					50020,
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
				
				SET @iteradorAux=@iteradorAux+1
 
			END
		
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50016,
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

