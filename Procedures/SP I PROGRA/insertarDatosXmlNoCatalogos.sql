/****** Object:  StoredProcedure [dbo].[insertarDatosXml]    Script Date: 14/11/2020 15:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarDatosXmlNoCatalogos]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script para insertar los datos en las tablas que no son catalogos, tomar en cuenta que en caso de no existir los catalogos el script no va a servir
	DELETE Beneficiario
	DELETE Usuario_Ver
	DELETE Usuario
	DELETE EstadoCuenta
	DELETE CuentaAhorros
	DELETE Persona

		---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 20)
	--select * from DatosXml



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
		x.Rec.value('@fechaFin[1]','date'),
		x.Rec.value('@saldoInicial[1]','float'),
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

