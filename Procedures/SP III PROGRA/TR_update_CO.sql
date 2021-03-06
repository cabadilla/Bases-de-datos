/****** Object:  Trigger [dbo].[TR_update_CO]    Script Date: 22/12/2020 19:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_update_CO]
   ON  [dbo].[CuentaObjetivo]
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
	VALUES  (5,
			(SELECT U.Id FROM dbo.Usuario U WHERE U.inSesion=1),
			(SELECT ABS(CHECKSUM(NEWID()))),
			@Existingdate,
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM deleted CO
			FOR XML AUTO),
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM inserted CO
			FOR XML AUTO),
			'Pagina web')
	
END
