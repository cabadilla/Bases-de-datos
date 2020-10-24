/****** Object:  StoredProcedure [dbo].[verMovimientoCO]    Script Date: 23/10/2020 18:31:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verMovimientoCO]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
			,[IdTipoMovimientoCo] 
			,[IdCuentaObjetivo] 
			,[Fecha] 
			,[Monto] 
		FROM [dbo].[MovimientoCO]
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END