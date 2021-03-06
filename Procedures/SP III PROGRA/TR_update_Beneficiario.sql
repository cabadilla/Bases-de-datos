/****** Object:  Trigger [dbo].[TR_update_Beneficiario]    Script Date: 22/12/2020 19:31:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[TR_update_Beneficiario]
   ON  [dbo].[Beneficiario]
   AFTER UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	

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
	VALUES  (2,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM deleted B
			FOR XML AUTO),
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM inserted B
			FOR XML AUTO),
			'Pagina web')
	
END