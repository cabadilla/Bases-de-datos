SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TR_update_Beneficiario]
   ON  [dbo].[Beneficiario]
   AFTER UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	

	DECLARE @Existingdate datetime
	SET @Existingdate=GETDATE()
	Select CONVERT(varchar,@Existingdate,3) as [DD/MM/YY]
	

    INSERT INTO [dbo].[Eventos](
				[idTipoEvento],
				[idUser],
				[IP],
				[Fecha],
				[XMLAntes],
				[XMLDespues])
	VALUES  (2,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM deleted B
			FOR XML AUTO),
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM inserted B
			FOR XML AUTO))
	
END