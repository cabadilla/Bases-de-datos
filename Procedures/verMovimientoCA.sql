SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verMovimientoCA]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
			,[Fecha] 
			,[Monto] 
			,[NuevoSaldo]
			,[IdTipoMovimientoCA] 
			,[IdCuentaAhorros]
			,[IdEstadoCuenta]
		FROM [dbo].[MovimientoCA]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END