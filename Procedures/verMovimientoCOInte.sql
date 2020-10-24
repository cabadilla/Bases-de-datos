SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verMovimientoCOInte]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
			,[IdTipoMovimientoCoInte] 
			,[IdCuentaObjetivo] 
			,[Fecha] 
			,[Monto] 
		FROM [dbo].[MovimientoCOInte]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END