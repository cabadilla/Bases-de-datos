
ALTER TRIGGER [dbo].[TR_insert_CO]
   ON  [dbo].[CuentaObjetivo]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
	 DECLARE @x xml
	 SET @x='';
	
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
	VALUES  (4,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			@x,
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM inserted CO
			FOR XML AUTO))
	
END
GO
