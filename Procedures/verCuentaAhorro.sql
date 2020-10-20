CREATE PROCEDURE [DBO].[verCuentaAhorro]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


SELECT [Id]
      ,[NumeroCuenta]
      ,[IdTipoCuentaAhorros]
      ,[IdCliente]
      ,[Saldo]
      ,[FechaCreacion]
  FROM [dbo].[CuentaAhorros]
  WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END

