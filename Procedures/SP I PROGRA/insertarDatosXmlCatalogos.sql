/****** Object:  StoredProcedure [dbo].[insertarDatosXml]    Script Date: 14/11/2020 15:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarDatosXmlCatalogos]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
----Script de inserccion de catalogos, primero limpia las tablas y despues reinserta los catalogos desde el XML de datos ubicado en una tabla de la base de datos

	DELETE TipoCuentaAhorros
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



	
	END TRY
	BEGIN CATCH


	END CATCH

END
