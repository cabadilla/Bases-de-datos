SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarMovimientoCOInte]
    -- Parámetros del SP
    @IdTipoMovimientoCOInte int,
	@IdCuentaObjetivo int,
	@Fecha date,
	@Monto float
	
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		INSERT INTO [dbo].[MovimientoCOInte]
				   ([IdTipoMovimientoCoInte]
				   ,[IdCuentaObjetivo]
				   ,[Fecha]
				   ,[Monto])
			 VALUES
				   (@IdTipoMovimientoCOInte
				   ,@IdCuentaObjetivo
				   ,@Fecha
				   ,@Monto
					)
	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END