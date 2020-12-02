/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatos]    Script Date: 1/12/2020 18:59:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[scripInserccionDeDatos]
AS
BEGIN
SET NOCOUNT ON
	---BEGIN TRY

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
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 21)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia date
	DECLARE @longitudDatos int
	DECLARE @iterador int

	
	
	DECLARE @idPersona int
	DECLARE @valorDoc int

	DECLARE @idCuenta int
	DECLARE @numeroCuenta int

---contador e iterador que se van a usar
	DECLARE @contadorAux int
	DECLARE @iteradorAux int 


	DECLARE @idEstadoCuenta int
	DECLARE @saldo float
	DECLARE @monto float
	DECLARE @tipoMovimiento int



----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)
	SET @iterador=1

	WHILE @iterador<=@longitudDatos
	BEGIN
		SELECT @dia= x.Rec.value('@Fecha','date')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]') AS x(Rec)
		
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
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Persona') AS x(Rec)

		----fin de inserccion de personas

			----insercion cuentas


		SELECT @contadorAux=COUNT(x.Rec.value('@ValorDocumentoIdentidadDelCliente','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta') AS x(Rec)

		SET @iteradorAux=1

		WHILE @iteradorAux<=@contadorAux
		BEGIN
			---se obtiene el id del cliente

			Select @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

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
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END
		----fin insercion cuentas


		-----insercion beneficiarios

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN
		
		----se consigue el valor de la llave de la persona que es el beneficiario
			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idPersona=P.Id 
			FROM Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc

			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

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
	
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1
		END
		----fin insercion beneficiarios

		-----insercion usuarios
		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@User','varchar(100)'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Usuario') AS x(Rec)

		WHILE @iteradorAux<=@contadorAux
		BEGIN

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
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Usuario[sql:variable("@iteradorAux")]') AS x(Rec)

			SET @iteradorAux=@iteradorAux+1

		END



		----fin insercion usuarios

		----insercion usuariosVer

		SET @iteradorAux=1
		SELECT @contadorAux= COUNT(x.Rec.value('@User','varchar(100)'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/UsuarioPuedeVer') AS x(Rec)

			WHILE @iteradorAux<=@contadorAux
			BEGIN

			INSERT INTO [dbo].[Usuario_Ver]
				(Usuario,
				NumeroCuenta
				)
			SELECT 
				x.Rec.value('@User','varchar(100)'),
				x.Rec.value('@NumeroCuenta','int')
			
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/UsuarioPuedeVer[sql:variable("@iteradorAux")]') AS x(Rec)
			SET @iteradorAux=@iteradorAux+1

		END

		----fin insercion usuarios ver


		----insercion movimiento 

		SELECT @contadorAux=COUNT(x.Rec.value('@CodigoCuenta','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos') AS x(Rec)

		SET @iteradorAux=1
		WHILE @iteradorAux<=@contadorAux
		BEGIN
		----Se consigue el id de la cuenta a la que se asocia

			SELECT @numeroCuenta = x.Rec.value('@CodigoCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			SELECT @idCuenta = C.Id
			FROM dbo.CuentaAhorros C
			WHERE C.NumeroCuenta = @numeroCuenta

		-----se consige el id del estado de cuenta correspondiente, va a conseguir el ultimo estado de cuenta al que se asocie el numero de cuenta

			SELECT @idEstadoCuenta = C.Id
			FROM dbo.EstadoCuenta C
			WHERE C.IdCuentaAhorro = @idCuenta


		---Se llama a un Sp que va a calcular el nuevo saldo
		
		SELECT @monto=x.Rec.value('@Monto','float')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

		SELECT @tipoMovimiento=x.Rec.value('@Tipo','int')
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

		EXEC calcularSaldoCuentaAhorro @idCuenta, @monto, @tipoMovimiento,@nuevoSaldo=@saldo OUTPUT

		---Comienza la insercion

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
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Movimientos[sql:variable("@iteradorAux")]') AS x(Rec)

			---UNA VEZ QUE EL MOVIMIENTO SE INSERTA CORRECTAMENTE, SE LE CAMBIA A LA CUENTA EL NUEVO SALDO
			UPDATE [dbo].[CuentaAhorros]
			   SET 
				  [Saldo] = @saldo
			 WHERE CuentaAhorros.Id=@idCuenta

			
			SET @iteradorAux=@iteradorAux+1
		END

		----fin insercion movimientos

		SET @iterador=@iterador+1
	END

	---END TRY
	---BEGIN CATCH

	---print('Algo salio mal')

	---END CATCH

END
