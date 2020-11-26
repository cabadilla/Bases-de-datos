/****** Object:  StoredProcedure [dbo].[insertarDatosXmlNoCatalogos]    Script Date: 14/11/2020 17:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[scripInserccionDeDatos]
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
---Dependiendo del id equivale al xml que se necesita, usar la consulta a DatosXml para saber cual necesitamos
	DECLARE @doc XML
	SET @doc=(SELECT [XML] FROM DatosXml WHERE  Id= 21)
----Declaracion de variables necesarias dia es la fecha sobre la cual se esta insertando y longitudDatos es la cantidad de fechas que existen
	DECLARE  @dia date
	DECLARE @longitudDatos int
	DECLARE @iterador int

----Se le envia el valor a longitud
	SELECT @longitudDatos=COUNT(x.Rec.value('@Fecha','date'))
	FROM @doc.nodes('/Operaciones/FechaOperacion') AS x(Rec)

	SET @iterador=0

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



		SET @iterador =@iterador+1
	END

	END TRY
	BEGIN CATCH


	END CATCH

END
select * from Persona