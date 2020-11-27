/****** Object:  StoredProcedure [dbo].[scripInserccionDeDatos]    Script Date: 27/11/2020 15:53:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[scripInserccionDeDatos]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

	DELETE Beneficiario
	DELETE Usuario_Ver
	DELETE Usuario
	DELETE EstadoCuenta
	DELETE CuentaObjetivo
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

	DECLARE @contadorBene int
	DECLARE @iteradorBene int 

	DECLARE @contadorCuentas int
	DECLARE @iteradorCuentas int

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


		SELECT @contadorCuentas=COUNT(x.Rec.value('@ValorDocumentoIdentidadDelCliente','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta') AS x(Rec)

		SET @iteradorCuentas=1

		WHILE @iteradorCuentas<=@contadorCuentas
		BEGIN
			---se obtiene el id del cliente

			Select @valorDoc =x.Rec.value('@ValorDocumentoIdentidadDelCliente','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorCuentas")]') AS x(Rec)

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
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Cuenta[sql:variable("@iteradorCuentas")]') AS x(Rec)

			SET @iteradorCuentas=@iteradorCuentas+1

		END
		----fin insercion cuentas


		-----insercion beneficiarios

		SET @iteradorBene=1
		SELECT @contadorBene= COUNT(x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int'))
		FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario') AS x(Rec)

		WHILE @iteradorBene<=@contadorBene
		BEGIN
		
		----se consigue el valor de la llave de la persona que es el beneficiario
			SELECT @valorDoc =x.Rec.value('@ValorDocumentoIdentidadBeneficiario','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorBene")]') AS x(Rec)

			SELECT @idPersona=P.Id 
			FROM Persona P
			WHERE P.ValorDocumentoIdentidad=@valorDoc

			----Se consige el id de la cuenta que se asocia al beneficiario
			SELECT @numeroCuenta = x.Rec.value('@NumeroCuenta','int')
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorBene")]') AS x(Rec)

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
	
			FROM @doc.nodes('/Operaciones/FechaOperacion[sql:variable("@iterador")]/Beneficiario[sql:variable("@iteradorBene")]') AS x(Rec)

			SET @iteradorBene=@iteradorBene+1
		END
		----fin insercion beneficiarios
		----insercion movimiento 



		----fin insercion movimientos

		SET @iterador=@iterador+1
	END

	END TRY
	BEGIN CATCH

	print('Algo salio mal')

	END CATCH

END




	exec scripInserccionDeDatos

	select * from DatosXml
	select * from Persona
	select * from Beneficiario
	select * from CuentaAhorros