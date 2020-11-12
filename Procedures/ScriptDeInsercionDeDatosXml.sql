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
	declare @doc xml
	set @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 19)
	--select * from DatosXml




	-------------------------------------------------------------------------------------------------------
	
	insert into DBO.Parentezco(Id,Nombre)
	select 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	from @doc.nodes('/Datos/Parentezcos/Parentezco') as x(Rec)




-------------------------------------------------------------------------------------------------------

	insert into DBO.TipoDocumentoIdentidad(Id,Nombre)
	select 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	from @doc.nodes('/Datos/Tipo_Doc/TipoDocuIdentidad') as x(Rec)

-------------------------------------------------------------------------------------------------------

	insert into DBO.TipoMoneda(Id,Tipo,Simbolo)
	select 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@Simbolo[1]','varchar(100)')
	from @doc.nodes('/Datos/Tipo_Moneda/TipoMoneda') as x(Rec)

-------------------------------------------------------------------------------------------------------

insert into DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
	select 
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
	from @doc.nodes('/Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') as x(Rec)

-------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------

	insert into DBO.Persona(IdTipoDocumentoIdentidad,Nombre,ValorDocumentoIdentidad,FechaNacimiento,Email,telefono1,telefono2,isActivo)
	select 
		x.Rec.value('@TipoDocuIdentidad[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@ValorDocumentoIdentidad[1]','int'),
		x.Rec.value('@FechaNacimiento[1]','date'),
		x.Rec.value('@Email[1]','varchar(100)'),
		x.Rec.value('@telefono1[1]','int'),
		x.Rec.value('@telefono2[1]','int'),
		1
	from @doc.nodes('/Datos/Personas/Persona') as x(Rec)

-------------------------------------------------------------------------------------------------------

	insert into DBO.CuentaAhorros(NumeroCuenta,IdTipoCuentaAhorros,IdCliente,Saldo,FechaCreacion)
	select 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@TipoCuentaId[1]','int'),
		x.Rec.value('@ValorDocumentoIdentidadDelCliente[1]','int'),
		x.Rec.value('@Saldo[1]','float'),
		x.Rec.value('@FechaCreacion[1]','date')
	from @doc.nodes('/Datos/Cuentas/Cuenta') as x(Rec)
-------------------------------------------------------------------------------------------------------
	insert into DBO.EstadoCuenta(IdCuentaAhorro,FechaInicio,FechaFinal,SaldoInicial,SaldoFinal)
	select 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@fechaInicio[1]','date'),
		x.Rec.value('@fechafin[1]','date'),
		x.Rec.value('@saldoinicial[1]','float'),
		x.Rec.value('@saldo_final[1]','float')
	from @doc.nodes('/Datos/Estados_de_Cuenta/Estado_de_Cuenta') as x(Rec)


-----------------------------------------------------------------------------------
	INSERT INTO [dbo].[Beneficiario]
				   ([IdCuentaAhorros]
				   ,[IdParentezco]
				   ,[porcentaje]
				   ,[valorDocumentoIdentidad]
				   ,[isActivo])
	select 
		x.Rec.value('@NumeroCuenta[1]','int'),
		x.Rec.value('@ParentezcoId[1]','int'),
		x.Rec.value('@Porcentaje[1]','int'),
		x.Rec.value('@ValorDocumentoIdentidadBeneficiario[1]','int'),
		1
	
	from @doc.nodes('/Datos/Beneficiarios/Beneficiario') as x(Rec)

---------------------------------------------------------------------------------


	insert into DBO.Usuario(Usuario,Contrasena,EsAdministrador,isActivo)
	select 
		x.Rec.value('@User[1]','varchar(100)'),
		x.Rec.value('@Pass[1]','varchar(100)'),
		x.Rec.value('@EsAdministrador[1]','int'),
		1
	from @doc.nodes('/Datos/Usuarios/Usuario') as x(Rec)


-------------------------------------------------------------------------------------------------------

	INSERT INTO [dbo].[Usuario_Ver]
			   ([Usuario]
			   ,[NumeroCuenta])
	select 
		x.Rec.value('@User[1]','nchar(100)'),
		x.Rec.value('@NumeroCuenta[1]','int')
	from @doc.nodes('/Datos/Usuarios_Ver/UsuarioPuedeVer') as x(Rec)


-------------------------------------------------------------------------------------------------------
	
	END TRY
	BEGIN CATCH


	END CATCH

END

