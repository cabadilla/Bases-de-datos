/****** Object:  StoredProcedure [dbo].[ConsultaBeneficiariosAdministrador]    Script Date: 22/12/2020 15:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ConsultaCuentasMultadas]
	@dias INT
AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY
		DECLARE @idCuenta INT
		DECLARE @iteradorAux INT
		DECLARE @contadorAux INT
		DECLARE @fechaUltima DATE
		DECLARE @retirosPromedio INT
		DECLARE @longitudDatos INT
		DECLARE @doc xml
		DECLARE @cantRetiros INT
		DECLARE @consulta TABLE
			(cuenta INT,
			 promedio FLOAT,
			 fechaMayorCantRetiros DATE
			)
		SELECT @contadorAux = COUNT(Id) FROM CuentaAhorros 
		SET @iteradorAux=0
		SET @idCuenta=0

		--AQUI TOMA la ultima fecha
		SELECT @doc = DX.XML FROM DatosXml DX WHERE DX.Id = 6 

		SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
		FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

		SELECT @fechaUltima= x.Rec.value('@Fecha','date')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@longitudDatos")]') AS x(Rec)
		
		--
		

		WHILE @iteradorAux<=@contadorAux
		BEGIN 
				--Toma una cuenta de la tabla de CuentaAhorro
				SELECT TOP 1 @idCuenta=CA.Id
				FROM DBO.CuentaAhorros CA
				WHERE CA.Id > @idCuenta

				--Cantidad de retiros para se multa
				SELECT @cantRetiros = tca.NumRetirosAutomatico 
				FROM dbo.TipoCuentaAhorros TCA 
				WHERE TCA.Id = (SELECT CA.IdTipoCuentaAhorros 
								FROM dbo.CuentaAhorros CA 
								WHERE CA.Id = @idCuenta)
				print (@cantRetiros)

				--si no ha sido procesada, tiene al menos una multa  y tiene mas de 5 retiros hace menos de @dias dias
				IF NOT EXISTS(SELECT CM.cuenta FROM @consulta CM WHERE CM.cuenta=@idCuenta) 
				AND (EXISTS (SELECT CA.NumeroCuenta  FROM dbo.CuentaAhorros CA INNER JOIN EstadoCuenta EC ON EC.IdCuentaAhorro=@idCuenta AND (EC.numRetirosAuto>4)))
				AND EXISTS(SELECT COUNT(M.ID) FROM dbo.MovimientoCA M WHERE M.Fecha > (SELECT DATEADD(DAY,@dias,@fechaUltima)) AND M.IdCuentaAhorros=@idCuenta)
				BEGIN
				
					--calculo el promedio de retiros por mes de esa cuenta
					SELECT @retirosPromedio=SUM(EC.numRetirosAuto) FROM dbo.EstadoCuenta EC WHERE EC.IdCuentaAhorro = @idCuenta
					SELECT @retirosPromedio = @retirosPromedio/(SELECT COUNT(EC.Id) FROM dbo.EstadoCuenta EC WHERE EC.IdCuentaAhorro = @idCuenta)
					

					--insertar datos en la varible tabla
					INSERT INTO @consulta(cuenta, promedio,fechaMayorCantRetiros)
					SELECT   (SELECT CA.NumeroCuenta FROM CuentaAhorros CA WHERE CA.Id = @idCuenta),
							 @retirosPromedio,
							(SELECT Top 1 EC.FechaInicio
							 FROM dbo.EstadoCuenta EC
							 WHERE EC.numRetirosAuto =  (SELECT MAX(EC.numRetirosAuto ) 
														FROM dbo.EstadoCuenta EC 
														WHERE EC.IdCuentaAhorro = @idCuenta))


				END
				SET @iteradorAux=@iteradorAux+1
		END
		SELECT C.cuenta,C.promedio,FORMAT(C.fechaMayorCantRetiros,'yyyy/MM') FROM @consulta C
	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50010,
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

