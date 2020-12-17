/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatos]    Script Date: 7/12/2020 14:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[scripInserccionDeDatosTerceraProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
	DELETE Beneficiario
	DELETE CuentaObjetivo
	DELETE MovimientoCA
	DELETE Usuario
	DELETE Usuario_Ver
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE Persona
---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 2)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia date
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



----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

	SELECT @dia= x.Rec.value('@Fecha','date')
	FROM @doc.nodes('/Operaciones/FechaOperacion[1]') AS x(Rec)

	WHILE @dia<=(SELECT x.Rec.value('@Fecha','date') FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@longitudDatos")]') AS x(Rec))
	BEGIN

		-----Se revisa si se tiene que cerrar un estado de cuenta

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
				 
				EXEC hacerCierre @idCuenta,@dia
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

			Select @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			Select @idPersona = P.Id
			FROM dbo.Persona P
			WHERE P.ValorDocumentoIdentidad = @valorDoc
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
			FROM Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc

			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM dbo.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta

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

		INSERT INTO [dbo].[Usuario]
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

		INSERT INTO [dbo].[Usuario_Ver]
			(Usuario,
			NumeroCuenta
			)
		SELECT 
			x.Rec.value('@User','varchar(100)'),
			x.Rec.value('@NumeroCuenta','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/UsuarioPuedeVer') AS x(Rec)

		----fin insercion usuarios ver


		----insercion movimiento


		SELECT @contadorAux=COUNT(x.Rec.value('@CodigoCuenta','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
		----Se consigue el id de la cuenta a la que se asocia

			SELECT @numeroCuenta = x.Rec.value('@CodigoCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM dbo.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta

		-----se consige el id del estado de cuenta correspondiente, va a conseguir el ultimo estado de cuenta al que se asocie el numero de cuenta

			SELECT @idEstadoCuenta = C.Id
			FROM dbo.EstadoCuenta C
			WHERE C.IdCuentaAhorro = @idCuenta


		---Se llama a un Sp que va a calcular el nuevo saldo
		
			SELECT @monto=x.Rec.value('@Monto','float')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @tipoMovimiento=x.Rec.value('@Tipo','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[@Fecha=sql:variable("@dia")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			EXEC calcularSaldoCuentaAhorro @idCuenta, @monto, @tipoMovimiento,@nuevoSaldo=@saldo OUTPUT

			---Comienza la insercion
			BEGIN TRAN 
				INSERT INTO [dbo].[MovimientoCA]
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
				UPDATE [dbo].[CuentaAhorros]
				   SET 
					  [Saldo] = @saldo
				WHERE CuentaAhorros.Id=@idCuenta
		IF (@@Error<>0)
			ROLLBACK
		ELSE
			COMMIT TRAN

			SET @iteradorAux=@iteradorAux+1
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

		----fin insercion movimientos

		SELECT @dia= DATEADD(DAY,1,@dia)
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




exec scripInserccionDeDatosTerceraProgra
select * from Errores
SELECT * FROM DatosXml
SELECT * FROM Usuario_Ver
SELECT * FROM Beneficiario
SELECT * FROM Usuario
SELECT * FROM Persona
SELECT * FROM MovimientoCA
SELECT * FROM CuentaAhorros
SELECT * FROM EstadoCuenta
SELECT * FROM Eventos