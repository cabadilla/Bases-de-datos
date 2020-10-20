CREATE PROCEDURE [DBO].[modificarCuentaAhorro]
@Id int
,@NumeroCuenta int
,@IdTipoCuentaAhorros int
,@IdCliente int
,@Saldo float
,@FechaCreacion date
AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE [dbo].[CuentaAhorros]
	   SET [NumeroCuenta] = @NumeroCuenta
		  ,[IdTipoCuentaAhorros] = @IdTipoCuentaAhorros
		  ,[IdCliente] = @IdCliente
		  ,[Saldo] = @Saldo
		  ,[FechaCreacion] = @FechaCreacion

		WHERE Id=@Id
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END