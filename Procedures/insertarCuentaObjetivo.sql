/****** Object:  StoredProcedure [dbo].[insertarCuentaObjetivo]    Script Date: 24/11/2020 22:49:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarCuentaObjetivo]
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
				   ,[Objetivo]
				   ,[isActivo])
			 VALUES
				   (@IdCuentaAhorro
				   ,@FechaInicio
				   ,@FechaFin
				   ,@DiasRebajo
				   ,@Cuota
				   ,@Objetivo
				   ,1)
   
	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END