/****** Object:  StoredProcedure [dbo].[insertarCatalogosSegundaProgra]    Script Date: 8/12/2020 18:18:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarCatalogosSegundaProgra]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script de inserccion de catalogos, primero limpia las tablas y despues reinserta los catalogos desde el XML de datos ubicado en una tabla de la base de datos
	
	DELETE TipoMovimientoCA
	DELETE TipoCuentaAhorros
	DELETE TipoDocumentoIdentidad
	DELETE TipoMoneda
	DELETE Parentezco
	

		---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 1)
	--select * from DatosXml



	----INSERCCION DE CATALOGOS
	-------------------------------------------------------------------------------------------------------
	
	
	INSERT INTO DBO.Parentezco(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Parentezcos/Parentezco') AS x(Rec)




-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoDocumentoIdentidad(Id,Nombre)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Doc/TipoDocuIdentidad') AS x(Rec)

-------------------------------------------------------------------------------------------------------

	INSERT INTO DBO.TipoMoneda(Id,Tipo,Simbolo)
	SELECT 
		x.Rec.value('@Id[1]','int'),
		x.Rec.value('@Nombre[1]','varchar(100)'),
		x.Rec.value('@Simbolo[1]','varchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Moneda/TipoMoneda') AS x(Rec)

-------------------------------------------------------------------------------------------------------

INSERT INTO DBO.TipoCuentaAhorros(Id,Nombre,IdTipoMoneda,SaldoMinimo,MultaSaldoMin,CargoAnual,NumRetirosHumano,NumRetirosAutomatico,ComisionHumano,ComisionAutomatico,Intereses)
	SELECT 
		x.Rec.value('@Id','int'),
		x.Rec.value('@Nombre','varchar(100)'),
		x.Rec.value('@IdTipoMoneda','int'),
		x.Rec.value('@SaldoMinimo','float'),
		x.Rec.value('@MultaSaldoMin','float'),
		x.Rec.value('@CargoMensual','float'),
		x.Rec.value('@NumRetiroHumano','int'),
		x.Rec.value('@NumRetirosAutomatico','int'),
		x.Rec.value('@ComisionHumano','float'),
		x.Rec.value('@ComisionAutomatico','float'),
		x.Rec.value('@Interes','float')
	FROM @doc.nodes('/Catalogos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') AS x(Rec)

-------------------------------------------------------------------------------------------------------

INSERT INTO DBO.TipoMovimientoCA(Id,Nombre,Tipo)
	SELECT 
		x.Rec.value('@Id','int'),
		x.Rec.value('@Nombre','varchar(100)'),
		x.Rec.value('@Tipo','nchar(100)')
	FROM @doc.nodes('/Catalogos/Tipo_Movimientos/Tipo_Movimiento') AS x(Rec)


	
	END TRY
	BEGIN CATCH

		INSERT INTO [dbo].[Errores] VALUES(
		50004,
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