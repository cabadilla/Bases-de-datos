/****** Object:  StoredProcedure [dbo].[insertarEstadoCuenta]    Script Date: 23/10/2020 18:45:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarEstadoCuenta]
    -- Parámetros del SP
    @IdCuentaAhorro int,
	@FechaInicio date,
	@FechaFinal date,
	@SaldoInicial float,
	@SaldoFinal float

AS
BEGIN
SET NOCOUNT ON;
	--BEGIN TRY  
		INSERT INTO [dbo].[EstadoCuenta]
				   ([IdCuentaAhorro]
				   ,[FechaInicio]
				   ,[FechaFinal]
				   ,[SaldoInicial]
				   ,[SaldoFinal]
				   )
			 VALUES
				   (@IdCuentaAhorro,
					@FechaInicio,
					@FechaFinal,
					@SaldoInicial,
					@SaldoFinal 
				   )


	--END TRY
	--BEGIN CATCH

	--END CATCH
SET NOCOUNT OFF
END