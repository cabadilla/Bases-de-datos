SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[modificarMovimientoCOInte]
	@Id int,
	@IdTipoMovimientoCoInte int,
	@IdCuentaObjetivo int,
	@Fecha date,
	@Monto float

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[MovimientoCOInte]
			   SET [IdTipoMovimientoCoInte] = @IdTipoMovimientoCoInte
				  ,[IdCuentaObjetivo] = @IdCuentaObjetivo
				  ,[Fecha] = @Fecha
				  ,[Monto] = @Monto
				WHERE Id=@Id

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END