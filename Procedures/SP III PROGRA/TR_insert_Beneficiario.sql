SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TR_insert_Beneficiario]
   ON  [dbo].[Beneficiario]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @xml xml select @xml = '<Beneficiario />';

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
	VALUES  (1,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			@xml,
			(SELECT B.IdCuentaAhorros,B.IdPersona,B.IdParentezco,B.valorDocumentoIdentidad,B.porcentaje,B.isActivo,B.fechaDesactivacion,B.fechaInserccion,B.modoInserccion
			FROM inserted B
			FOR XML AUTO))
	
END