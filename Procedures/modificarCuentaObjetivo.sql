/****** Object:  StoredProcedure [dbo].[insertarCuentaObjetivo]    Script Date: 27/11/2020 11:03:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarCuentaObjetivo]
    -- Parámetros del SP
    @CuentaAhorro int,
	@FechaFin date,
	@DiasRebajo date,
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


		INSERT  dbo.CuentaObjetivo
				   ([IdCuentaAhorro]
				   ,[FechaInicio]
				   ,[FechaFin]
				   ,[DiasRebajo]
				   ,[Cuota]
				   ,[Objetivo]
				   ,[isActivo])
			 SELECT CA.Id
				   ,@Existingdate
				   ,@FechaFin
				   ,@DiasRebajo
				   ,@Cuota
				   ,@Objetivo
				   ,1
			FROM dbo.CuentaAhorros CA
			WHERE CA.NumeroCuenta = @CuentaAhorro
		
   
	END TRY
	BEGIN CATCH
	END CATCH
SET NOCOUNT OFF
END