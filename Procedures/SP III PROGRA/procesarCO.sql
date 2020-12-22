/****** Object:  StoredProcedure [dbo].[procesarCO]    Script Date: 21/12/2020 22:55:43 ******/
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
				
							UPDATE DBO.CuentaAhorros
							SET Saldo= Saldo-@cuota
							WHERE Id=@idCuentaAhorro

							INSERT DBO.MovimientoCA(
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
								(SELECT E.Id FROM DBO.EstadoCuenta E WHERE E.IdCuentaAhorro=@idCuentaAhorro),
								'Debito por cuenta objetivo'
							)

						---Depues de actualizar la cuenta de ahorros, se le suma a la cuenta objetivo el monto que corresponde y se 
						---inserta el movimiento
							UPDATE DBO.CuentaObjetivo
							SET Saldo=Saldo+@cuota
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
					
					END			
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

