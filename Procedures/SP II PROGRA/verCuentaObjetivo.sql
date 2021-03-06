/****** Object:  StoredProcedure [dbo].[verCuentaObjetivo]    Script Date: 27/11/2020 11:53:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verCuentaObjetivo]
	@cuentaAhorros int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		DECLARE @IdCuentaAhorro int
		SELECT @IdCuentaAhorro = CA.Id
		FROM CuentaAhorros CA
		WHERE CA.NumeroCuenta=@cuentaAhorros

		SELECT CO.FechaInicio
		  ,CO.FechaFin
		  ,CO.DiasRebajo
		  ,CO.Cuota
		  ,CO.Objetivo
	  FROM [dbo].[CuentaObjetivo] CO
	  WHERE CO.IdCuentaAhorro=@IdCuentaAhorro and CO.isActivo=1
	

	END TRY
	BEGIN CATCH

	END CATCH

END