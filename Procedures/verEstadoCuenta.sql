SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verEstadoCuenta]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
			,[IdCuentaAhorro]
			,[FechaInicio] 
			,[FechaFinal]
			,[SaldoInicial] 
			,[SaldoFinal]
		FROM [dbo].[EstadoCuenta]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END