ALTER PROCEDURE [dbo].[hacerCierre]
    -- Parámetros del SP
@idEstado int

AS
BEGIN
SET NOCOUNT ON;
	---BEGIN TRY  
		DECLARE @idCuenta int
		DECLARE @montoInteres INT
		DECLARE @montoMultasCajero int
		DECLARE @montoMultasVentana int
		DECLARE @multaSaldoMin int
		DECLARE @aux int
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

		----SE SACA EL VALOR AL QUE CORRESPONDEN LOS INTERESES Y SE LE SUMA A LA CUENTA
		SET @aux=(@aux*@montoInteres)/100

			UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = Saldo+@aux
		 WHERE Id=@idCuenta


		-----FIN INTERES MENSUAL
		----SE REBAJA EL CARGO MENSUAL

		---SE ENCUENTRA EL VALOR DEL CARGO MENSUAL
		SELECT @aux=T.CargoAnual
		FROM TipoCuentaAhorros T
		WHERE T.Id=@tipoCuenta
	----SE LE REBAJA A LA CUENTA EL VALOR CORRESPONDIENTE AL CARGO MENSUAL
		UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = Saldo-@aux
		 WHERE Id=@idCuenta

	----SE  CALCULA LA MULTA POR SALDO MINIMO

	SELECT @multaSaldoMin=T.SaldoMinimo
	FROM TipoCuentaAhorros T
	WHERE T.Id=@tipoCuenta

	SELECT @aux=C.Saldo
	FROM CuentaAhorros C
	WHERE C.Id=@idCuenta
	---DESPUES DE ENCONTRAR EL VALOR DEL SALDO MIN Y DEL SALDO DE LA CUENTA SE REALIZA UN IF PARA VERIFICAR SI SE LE DEBE DE REBAJAR
	IF @aux<@multaSaldoMin
		BEGIN
			UPDATE [dbo].[CuentaAhorros]
			SET
			  Saldo = Saldo-@multaSaldoMin
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

	--END TRY
	--BEGIN CATCH

	--END CATCH
SET NOCOUNT OFF
END

select * from TipoCuentaAhorros
select * from TipoMovimientoCA
select * from DatosXml


select * from CuentaAhorros
select * from EstadoCuenta

exec scripInserccionDeDatos
