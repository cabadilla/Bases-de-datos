CREATE PROCEDURE [dbo].[insertarCuentaObjetivo]
    -- Parámetros del SP
    @IdCuentaAhorro int,
	@FechaInicio date,
	@FechaFin date,
	@DiasRebajo date,
	@Cuota float,
	@Objetivo nchar(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  


		INSERT INTO [dbo].[CuentaObjetivo]
				   ([IdCuentaAhorro]
				   ,[FechaInicio]
				   ,[FechaFin]
				   ,[DiasRebajo]
				   ,[Cuota]
				   ,[Objetivo])
			 VALUES
				   (@IdCuentaAhorro
				   ,@FechaInicio
				   ,@FechaFin
				   ,@DiasRebajo
				   ,@Cuota
				   ,@Objetivo)
   
	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END