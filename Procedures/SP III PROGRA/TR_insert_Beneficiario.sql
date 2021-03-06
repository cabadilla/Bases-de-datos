/****** Object:  Trigger [dbo].[TR_insert_Beneficiario]    Script Date: 22/12/2020 19:31:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[TR_insert_Beneficiario]
   ON  [dbo].[Beneficiario]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @xml xml select @xml = '<Beneficiario />';

	DECLARE @Existingdate datetime
	SET @Existingdate=GETDATE()

    INSERT INTO [dbo].[Eventos](
				[idTipoEvento],
				[idUser],
				[IP],
				[Fecha],
				[XMLAntes],
				[XMLDespues],
				[insertAt])
	VALUES  (1,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			@xml,
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM inserted B
			FOR XML AUTO),
			'Pagina web')
	
END