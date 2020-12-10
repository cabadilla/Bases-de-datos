
CREATE TRIGGER [dbo].[TR_insert_CO]
   ON  [dbo].[CuentaObjetivo]
   AFTER INSERT
AS 
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 
	

	SELECT I.IdCuentaAhorro,I.Objetivo,I.Cuota,I.DiasRebajo,I.FechaInicio,I.FechaFin,I.isActivo
	FROM inserted I
	FOR XML AUTO
	
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
	VALUES (@IdTipoEvento,
			@IdUser,
			(SELECT client_net_address FROM sys.dm_exec_connections WHERE session_id = @@SPID),
			@Existingdate,
			NULL,
			(SELECT I.IdCuentaAhorro,I.Objetivo,I.Cuota,I.DiasRebajo,I.FechaInicio,I.FechaFin,I.isActivo
			FROM inserted I
			FOR XML AUTO))
	

END
GO
