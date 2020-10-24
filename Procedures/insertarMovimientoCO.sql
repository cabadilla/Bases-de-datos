SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insertarMovimientoCO]
    -- Parámetros del SP
    @IdTipoMovimientoCO int,
	@IdCuentaObjetivo int,
	@Fecha date,
	@Monto float
	
	
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		INSERT INTO [dbo].[MovimientoCO]
				   ([IdTipoMovimientoCo]
				   ,[IdCuentaObjetivo]
				   ,[Fecha]
				   ,[Monto])
			 VALUES
				   (@IdTipoMovimientoCO
				   ,@IdCuentaObjetivo
				   ,@Fecha
				   ,@Monto
					)
	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END