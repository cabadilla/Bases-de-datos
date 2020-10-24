/****** Object:  StoredProcedure [dbo].[modificarMovimientoCA]    Script Date: 23/10/2020 18:46:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarMovimientoCA]
	@Id int,
	@Fecha date,
	@Monto float,
	@NuevoSaldo float,
	@IdTipoMovimientoCA int,
	@IdCuentaAhorros int,
	@IdEstadoCuenta int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[MovimientoCA]
			   SET [Fecha] = @Fecha
				  ,[Monto] = @Monto
				  ,[NuevoSaldo] = @NuevoSaldo
				  ,[IdTipoMovimientoCA] = @IdTipoMovimientoCA
				  ,[IdCuentaAhorros] = @IdCuentaAhorros
				  
				WHERE Id=@Id

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END