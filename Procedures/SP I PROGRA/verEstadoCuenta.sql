/****** Object:  StoredProcedure [dbo].[verEstadoCuenta]    Script Date: 14/11/2020 16:18:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verEstadoCuenta]
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