CREATE PROCEDURE [DBO].[modificarCuentaObjetivo]
@Id int,
@IdCuentaAhorro int,
@FechaInicio date,
@FechaFin date,
@DiasRebajo date,
@Cuota float,
@Objetivo nchar(100)
AS
BEGIN    
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE [dbo].[CuentaObjetivo]
	   SET [IdCuentaAhorro] = @IdCuentaAhorro
		  ,[FechaInicio] = @FechaInicio
		  ,[FechaFin] = @FechaFin
		  ,[DiasRebajo] = @DiasRebajo
		  ,[Cuota] = @Cuota
		  ,[Objetivo] = @Objetivo

		WHERE Id=@Id
		
	END TRY
	BEGIN CATCH

	END CATCH
    SET NOCOUNT OFF;
END