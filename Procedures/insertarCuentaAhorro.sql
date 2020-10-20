CREATE PROCEDURE [dbo].[insertarCuentaAhorros]
    -- Parámetros del SP
    @NumeroCuenta int,
	@IdTipoCuentaAhorros int,
	@IdCliente int,
	@Saldo float,
	@FechaCreacion date
	
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		INSERT INTO [dbo].[CuentaAhorros]
				   ([NumeroCuenta]
				   ,[IdTipoCuentaAhorros]
				   ,[IdCliente]
				   ,[Saldo]
				   ,[FechaCreacion])
			 VALUES
				   (@NumeroCuenta
				   ,@IdTipoCuentaAhorros
				   ,@IdCliente
				   ,@Saldo
				   ,@FechaCreacion
					)
	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END