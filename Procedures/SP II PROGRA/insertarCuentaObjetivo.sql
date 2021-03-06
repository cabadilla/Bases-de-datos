/****** Object:  StoredProcedure [dbo].[insertarCuentaObjetivo]    Script Date: 12/12/2020 12:09:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarCuentaObjetivo]
    -- Parámetros del SP
    @CuentaAhorro int,
	@FechaFin date,
	@DiasRebajo int,
	@Cuota float,
	@Objetivo nchar(100)
AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  

		--Se establece la fecha de inicio
		DECLARE @Existingdate DATETIME
		SET @Existingdate=GETDATE()
		SELECT CONVERT(VARCHAR,@Existingdate,3) as [DD/MM/YY]

		--Se establece el id del cuenta 
		DECLARE @IdCuentaAhorro int;
		-- Inicializacion
		 SELECT @IdCuentaAhorro=CA.Id
		 FROM dbo.CuentaAhorros CA
		 WHERE CA.[NumeroCuenta]=@CuentaAhorro

		INSERT INTO [dbo].[CuentaObjetivo]
				   ([IdCuentaAhorro]
				   ,[FechaInicio]
				   ,[FechaFin]
				   ,[DiasRebajo]
				   ,[Cuota]
				   ,[Objetivo]
				   ,[isActivo])
			 VALUES
				   (@IdCuentaAhorro
				   ,@Existingdate
				   ,@FechaFin
				   ,@DiasRebajo
				   ,@Cuota
				   ,@Objetivo
				   ,1)
   
	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END