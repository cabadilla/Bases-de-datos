/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatosTerceraProgra]    Script Date: 22/12/2020 13:35:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[scripInserccionDeDatosTerceraProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	DELETE Eventos
	DELETE Beneficiario
	DELETE movimientosInteresCO
	DELETE MovimientoCO
	DELETE CuentaObjetivo
	DELETE MovimientoCA
	DELETE Usuario
	DELETE Usuario_Ver
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE Persona
---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 6)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia varchar(100)
	DECLARE @longitudDatos int
	
	DECLARE @idPersona int
	DECLARE @valorDoc int

	DECLARE @idCuenta int
	DECLARE @numeroCuenta int
	DECLARE @saldoMin int
	DECLARE @multaSaldo int

	DECLARE @idEstadoCuenta int
	DECLARE @saldo float
	DECLARE @monto float
	DECLARE @tipoMovimiento int
	DECLARE @contadorAux int
	DECLARE @iteradorAux int
	DECLARE @dias date
	DECLARE @cantidadMeses int



----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

	SELECT @dias= x.Rec.value('@Fecha','date')
	FROM @doc.nodes('/Operaciones/FechaOperacion[1]') AS x(Rec)
	

	WHILE @dias<=(SELECT x.Rec.value('@Fecha','date') FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@longitudDatos")]') AS x(Rec))
	BEGIN
		----lo primero que se hace es llamar a la funcion que calcula los intereses diarios de las cuentas objetivo
		EXEC procesarInteresesDiarios @dias
		---una vez que se calculan los nuevos intereses se procesan las cuentas objetivo y hace lo que se tenga que hacer en ese respectivo dia
		EXEC procesarCO @dias


		-----Se revisa si se tiene que cerrar un estado de cuenta
		SELECT @dia=CONVERT(varchar,@dias,110)
		SELECT @contadorAux=COUNT(C.Id)
		FROM EstadoCuenta C
		WHERE C.FechaFinal=@dia

		SET @iteradorAux=1
		SET @idCuenta=0
		WHILE @iteradorAux<=@contadorAux
			BEGIN 
				SELECT TOP 1 @idCuenta = C.Id
				FROM EstadoCuenta C
				WHERE C.Id > @idCuenta AND C.FechaFinal=@dia
				 
				EXEC hacerCierre @idCuenta,@dias
				SET @iteradorAux=@iteradorAux+1
			END


		------inserccion de personas en ese dia
		------inserccion de personas en ese dia

		INSERT INTO DBO.Persona(
		IdTipoDocumentoIdentidad,
		Nombre,
		ValorDocumentoIdentidad,
		FechaNacimiento,
		Email,
		telefono1,
		telefono2,
		isActivo,
		FechaActivacion,
		MedioInsercion)
		SELECT 
			x.Rec.value('@TipoDocuIdentidad','int'),
			x.Rec.value('@Nombre','varchar(40)'),
			x.Rec.value('@ValorDocumentoIdentidad','int'),
			x.Rec.value('@FechaNacimiento','date'),
			x.Rec.value('@Email','varchar(100)'),
			x.Rec.value('@Telefono1','int'),
			x.Rec.value('@Telefono2','int'),
			1,
			@dia,
			'Script'
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Persona') AS x(Rec)
		----fin de inserccion de personas
		
		----insercion de cuentas

		SELECT @contadorAux=COUNT(x.Rec.value('@ValorDocumentoIdentidadDelCliente','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta') AS x(Rec)

		SET @iteradorAux=1
		----este insert se hace iterando para que el trigger pueda funcionar  bien
		WHILE @iteradorAux<=@contadorAux
		BEGIN
			---se obtiene el id del cliente

			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona = P.Id
			FROM dbo.Persona P
			WHERE P.ValorDocumentoIdentidad = @valorDoc
			ORDER BY P.Id
			----comienza el insert


			INSERT INTO DBO.CuentaAhorros(
			NumeroCuenta,
			IdTipoCuentaAhorros,
			IdCliente,
			Saldo,
			FechaCreacion,
			modoInsercion)
			SELECT 
				x.Rec.value('@NumeroCuenta','int'),
				x.Rec.value('@TipoCuentaId','int'),
				@idPersona,
				0,
				@dia,
				'Script'
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END


		---fin insercion cuentas
		---insercion beneficiarios

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN
		
		----se consigue el valor de la llave de la persona que es el beneficiario
			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona=P.Id 
			FROM DBO.Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc
			ORDER BY P.Id
			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM DBO.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta
			ORDER BY C.Id
			---------Se hace el insert

			INSERT INTO [dbo].[Beneficiario]
						   ([IdCuentaAhorros]
						   ,[IdParentezco]
						   ,[IdPersona]
						   ,[porcentaje]
						   ,[valorDocumentoIdentidad]
						   ,[isActivo]
						   ,fechaInserccion
						   ,modoInserccion)
			SELECT 
				@idCuenta,
				x.Rec.value('@ParentezcoId','int'),
				@idPersona,
				x.Rec.value('@Porcentaje','int'),
				@valorDoc,
				1,
				@dia,
				'script'
	
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1
		END

		----fin insercion beneficiarios

		---INSERCION USUARIOS

		INSERT INTO DBO.Usuario
				(Usuario,
				Contrasena,
				isActivo,
				EsAdministrador
				)
		SELECT 
			x.Rec.value('@User','varchar(100)'),
			x.Rec.value('@Pass','varchar(100)'),
			1,
			x.Rec.value('@EsAdministrador','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Usuario') AS x(Rec)

		---FIN INSERCION USUARIOS

		----insercion usuariosVer

		INSERT INTO DBO.Usuario_Ver
			(Usuario,
			NumeroCuenta
			)
		SELECT 
			x.Rec.value('@User','varchar(100)'),
			x.Rec.value('@Cuenta','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/UsuarioPuedeVer') AS x(Rec)

		----fin insercion usuarios ver
		----insercion de cuentas objetivo

		SELECT @contadorAux=COUNT(x.Rec.value('@NumeroCuentaPrimaria','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuentaPrimaria','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta=C.Id 
			FROM CuentaAhorros C
			WHERE @numeroCuenta=C.NumeroCuenta
			ORDER BY C.Id

			---SE CALCULA A CUANTO CORRESPONDE LA TASA DE INTERESES
			SELECT @cantidadMeses=DATEDIFF(MONTH,@dias,x.Rec.value('@FechaFinal','date'))
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @monto=(@cantidadMeses*0.5)/365
			
			---SE INSERTA LA CUENTA OBJETIVO
			INSERT INTO [dbo].[CuentaObjetivo]
			   ([IdCuentaAhorro]
			   ,[FechaInicio]
			   ,[FechaFin]
			   ,[DiasRebajo]
			   ,[InteresesAcumulados]
			   ,[Saldo]
			   ,[TasaIntereses]
			   ,[Cuota]
			   ,[Objetivo]
			   ,[isActivo]
			   ,[depositos]
			   ,[depositosNoRealizados]
			   ,[codigoCuenta])
			SELECT
			    @idCuenta
			   ,@dias
			   ,x.Rec.value('@FechaFinal','date')
			   ,x.Rec.value('@DiaAhorro','int')
			   ,0
			   ,0
			   ,@monto
			   ,x.Rec.value('@MontoAhorro','float')
			   ,x.Rec.value('@Descripcion','varchar(100)')
			   ,1
			   ,0
			   ,0
			   ,x.Rec.value('@NumeroCuentaAhorro','varchar(100)')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/CuentaAhorro[sql:variable("@iteradorAux")]') AS x(Rec)
			SET @iteradorAux=@iteradorAux+1
		END

		-----fin insercion
		


		----insercion movimiento


		SELECT @contadorAux=COUNT(x.Rec.value('@CodigoCuenta','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
		----Se consigue el id de la cuenta a la que se asocia

			SELECT @numeroCuenta = x.Rec.value('@CodigoCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)


		-----se consige el id del estado de cuenta correspondiente, va a conseguir el ultimo estado de cuenta al que se asocie el numero de cuenta

			SELECT @idCuenta=C.Id, @idEstadoCuenta = E.Id
			FROM DBO.CuentaAhorros C
			INNER JOIN DBO.EstadoCuenta E ON E.IdCuentaAhorro=C.Id
			WHERE C.NumeroCuenta = @numeroCuenta
			ORDER BY C.Id



		---Se llama a un Sp que va a calcular el nuevo saldo
		
			SELECT @monto=x.Rec.value('@Monto','float')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @tipoMovimiento=x.Rec.value('@Tipo','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			EXEC calcularSaldoCuentaAhorro @idCuenta, @monto, @tipoMovimiento,@nuevoSaldo=@saldo OUTPUT

			---Comienza la insercion
			BEGIN TRAN 
				INSERT INTO DBO.MovimientoCA
				   ([Monto]
				   ,[Fecha]
				   ,[NuevoSaldo]
				   ,[IdTipoMovimientoCA]
				   ,[IdCuentaAhorros]
				   ,[IdEstadoCuenta]
				   ,[Descripcion])
				SELECT 
					@monto,
					@dia,
					@saldo,
					@tipoMovimiento,
					@idCuenta,
					@idEstadoCuenta,
					x.Rec.value('@Descripcion','nchar(100)')
				FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

				---UNA VEZ QUE EL MOVIMIENTO SE INSERTA CORRECTAMENTE, SE LE CAMBIA A LA CUENTA EL NUEVO SALDO
				UPDATE DBO.CuentaAhorros
				   SET 
					  [Saldo] = @saldo
				WHERE CuentaAhorros.Id=@idCuenta
			IF (@@Error<>0)
				ROLLBACK
			ELSE
				COMMIT TRAN

				------Se revisa si se le debe sumar al numero de retiros ventana o atm

				IF @tipoMovimiento=2
					BEGIN 
						BEGIN TRAN 
							UPDATE DBO.EstadoCuenta
								SET [numRetirosAuto]=numRetirosAuto+1
							WHERE Id=@idEstadoCuenta
						IF (@@Error<>0)
							ROLLBACK
						ELSE
							COMMIT TRAN

					END

				IF @tipoMovimiento=3
					BEGIN 
						BEGIN TRAN 
							UPDATE DBO.EstadoCuenta
								SET [numRetirosVentana]=numRetirosVentana+1
							WHERE Id=@idEstadoCuenta
						IF (@@Error<>0)
							ROLLBACK
						ELSE
							COMMIT TRAN

					END

				---se revisa el saldo minimo
			SELECT @saldoMin=E.SaldoMinimo FROM DBO.EstadoCuenta E WHERE E.Id=@idEstadoCuenta
			IF @saldoMin>@saldo OR @saldoMin=0
				BEGIN
					UPDATE DBO.EstadoCuenta
					SET 
						[SaldoMinimo]=@saldo
					WHERE Id=@idEstadoCuenta
				END


			SET @iteradorAux=@iteradorAux+1
		END


		----fin insercion movimientos

		SELECT @dias= DATEADD(DAY,1,@dias)
	END
		

	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50005,
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