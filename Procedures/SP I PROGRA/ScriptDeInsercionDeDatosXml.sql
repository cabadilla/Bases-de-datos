/****** Object:  StoredProcedure [dbo].[insertarDatosXml]    Script Date: 13/11/2020 20:05:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarDatosXml]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script para insertar los datos, primero borra todas las tablas y carga desde un xml almacenado en una tabla 
----todos los valores a sus respectivas tablas, se hace en un orden especifico para que no genere conflictos

	DELETE Beneficiario
	DELETE Usuario_Ver
	DELETE Usuario
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE TipoCuentaAhorros
	DELETE Persona
	DELETE TipoDocumentoIdentidad
	DELETE TipoMoneda
	DELETE Parentezco

		---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 20)
	--select * from DatosXml



	----INSERCCION DE CATALOGOS
	-------------------------------------------------------------------------------------------------------
	
	
	INSERT INTO DBO.Parentezco(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Datos/Parentezcos/Parentezco') AS x(Rec)




-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoDocumentoIdentidad(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Datos/Tipo_Doc/TipoDocuIdentidad') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMoneda(Id,Tipo,Simbolo)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@Simbolo[1]','varchar(100)')
	FROM @doc.nodes('/Datos/Tipo_Moneda/TipoMoneda') AS x(Rec)

-------------------------------------------------------------------------------------------------------

INSERT INTO DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@IdTipoMoneda[1]','int'),
		x.Rec.value('@SaldoMinimo[1]','float'),
		x.Rec.value('@MultaSaldoMin[1]','float'),
		x.Rec.value('@CargoAnual[1]','float'),
		x.Rec.value('@NumRetirosHumano[1]','int'),
		x.Rec.value('@NumRetirosAutomatico[1]','int'),
		x.Rec.value('@comisionHumano[1]','float'),
		x.Rec.value('@comisionAutomatico[1]','float'),
		x.Rec.value('@interes[1]','float')
	FROM @doc.nodes('/Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') AS x(Rec)

-------------------------------------------------------------------------------------------------------


--A PARTIR DE AQUÍ SE INSERTAN LAS TABLAS NO CATALOGOS, ESTA ACOMODADO DE MANERA QUE NO DE PROBLEMAS CON LAS LLAVES FORANEAS
-----------------------------------------------------------------------------------------------------------

	DECLARE @Existingdate DATETIME
	SET @Existingdate=GETDATE()
	SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

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
		x.Rec.value('@TipoDocuIdentidad[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(40)'),
		x.Rec.value('@ValorDocumentoIdentidad[1]','int'),
		x.Rec.value('@FechaNacimiento[1]','date'),
		x.Rec.value('@Email[1]','varchar(100)'),
		x.Rec.value('@telefono1[1]','int'),
		x.Rec.value('@telefono2[1]','int'),
		1,
		@Existingdate,
		'Script'
	FROM @doc.nodes('/Datos/Personas/Persona') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.CuentaAhorros(NumeroCuenta,
	IdTipoCuentaAhorros,
	IdCliente,
	Saldo,
	FechaCreacion,
	modoInsercion)
	SELECT 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@TipoCuentaId[1]','int'),
		x.Rec.value('@ValorDocumentoIdentidadDelCliente[1]','int'),
		x.Rec.value('@Saldo[1]','float'),
		x.Rec.value('@FechaCreacion[1]','date'),
		'Script'
	FROM @doc.nodes('/Datos/Cuentas/Cuenta') AS x(Rec)
-------------------------------------------------------------------------------------------------------
	INSERT INTO DBO.EstadoCuenta(IdCuentaAhorro,FechaInicio,FechaFinal,SaldoInicial,SaldoFinal)
	SELECT 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@fechaInicio[1]','date'),
		x.Rec.value('@fechafin[1]','date'),
		x.Rec.value('@saldoinicial[1]','float'),
		x.Rec.value('@saldo_final[1]','float')
	FROM @doc.nodes('/Datos/Estados_de_Cuenta/Estado_de_Cuenta') AS x(Rec)


-----------------------------------------------------------------------------------
	INSERT INTO [dbo].[Beneficiario]
				   ([IdCuentaAhorros]
				   ,[IdParentezco]
				   ,[porcentaje]
				   ,[valorDocumentoIdentidad]
				   ,[isActivo]
				   ,fechaInserccion
				   ,modoInserccion)
	SELECT 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@ParentezcoId[1]','int'),
		x.Rec.value('@Porcentaje[1]','int'),
		x.Rec.value('@ValorDocumentoIdentidadBeneficiario[1]','int'),
		1,
		@Existingdate,
		'script'
	
	FROM @doc.nodes('/Datos/Beneficiarios/Beneficiario') AS x(Rec)

---------------------------------------------------------------------------------


	INSERT INTO DBO.Usuario(Usuario,Contrasena,EsAdministrador,isActivo)
	SELECT 
		x.Rec.value('@User[1]','varchar(100)'),
		x.Rec.value('@Pass[1]','varchar(100)'),
		x.Rec.value('@EsAdministrador[1]','int'),
		1
	FROM @doc.nodes('/Datos/Usuarios/Usuario') AS x(Rec)


-------------------------------------------------------------------------------------------------------

	INSERT INTO [dbo].[Usuario_Ver]
			   ([Usuario]
			   ,[NumeroCuenta])
	SELECT 
		x.Rec.value('@User[1]','nchar(100)'),
		x.Rec.value('@NumeroCuenta[1]','int')
	FROM @doc.nodes('/Datos/Usuarios_Ver/UsuarioPuedeVer') AS x(Rec)


-------------------------------------------------------------------------------------------------------
	
	END TRY
	BEGIN CATCH


	END CATCH

END

exec insertarDatosXml

SELECT * FROM Beneficiario