/****** Object:  StoredProcedure [dbo].[insertarMovimientoCA]    Script Date: 23/10/2020 18:44:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarMovimientoCA]
    -- Parámetros del SP

    @Fecha date,
	@Monto float,
	@NuevoSaldo float,
	@IdTipoMovimientoCA int,
	@IdCuentaAhorros int,
	@IdEstadoCuenta int 

AS
BEGIN
SET NOCOUNT ON;
	--BEGIN TRY  
		INSERT INTO [dbo].[MovimientoCA]
				   ([Fecha]
				   ,[Monto]
				   ,[NuevoSaldo]
				   ,[IdTipoMovimientoCA]
				   ,[IdCuentaAhorros]
				   ,[IdEstadoCuenta]
				   )
			 VALUES
				   (@Fecha,
					@Monto,
					@NuevoSaldo,
					@IdTipoMovimientoCA,
					@IdCuentaAhorros,
					@IdEstadoCuenta  
				   )
	--END TRY
	--BEGIN CATCH

	--END CATCH
SET NOCOUNT OFF
END