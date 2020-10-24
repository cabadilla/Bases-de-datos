/****** Object:  StoredProcedure [dbo].[modificarMovimientoCO]    Script Date: 23/10/2020 18:48:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarMovimientoCO]
	@Id int,
	@IdTipoMovimientoCo int,
	@IdCuentaObjetivo int,
	@Fecha date,
	@Monto float

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[MovimientoCO]
			   SET [IdTipoMovimientoCo] = @IdTipoMovimientoCo
				  ,[IdCuentaObjetivo] = @IdCuentaObjetivo
				  ,[Fecha] = @Fecha
				  ,[Monto] = @Monto
				WHERE Id=@Id

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END