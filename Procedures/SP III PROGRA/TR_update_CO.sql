SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TR_update_CO]
   ON  [dbo].[CuentaObjetivo]
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
	VALUES  (5,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM deleted CO
			FOR XML AUTO),
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM inserted CO
			FOR XML AUTO))
	
END
