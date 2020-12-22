/****** Object:  Trigger [dbo].[TR_insert_CO]    Script Date: 21/12/2020 11:19:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_insert_CO]
   ON  [dbo].[CuentaObjetivo]
   AFTER INSERT
AS 
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @xml xml select @xml = '<CuentaObjetivo />';

	DECLARE @Existingdate datetime
	SET @Existingdate=GETDATE()
	

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
			@xml,
			(SELECT CO.IdCuentaAhorro,CO.Cuota,CO.DiasRebajo,CO.FechaInicio,CO.FechaFin,CO.isActivo,CO.Objetivo
			FROM inserted CO
			FOR XML AUTO))
	
END
