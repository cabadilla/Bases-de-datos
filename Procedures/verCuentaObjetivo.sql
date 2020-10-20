CREATE PROCEDURE [dbo].[verCuentaObjetivo]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

		SELECT [Id]
		  ,[IdCuentaAhorro]
		  ,[FechaInicio]
		  ,[FechaFin]
		  ,[DiasRebajo]
		  ,[Cuota]
		  ,[Objetivo]
	  FROM [dbo].[CuentaObjetivo]
	
		WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END