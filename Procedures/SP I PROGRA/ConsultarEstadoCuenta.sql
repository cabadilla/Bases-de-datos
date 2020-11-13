/****** Object:  StoredProcedure [dbo].[ConsultarEstadoCuenta]    Script Date: 12/11/2020 21:40:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ConsultarEstadoCuenta]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
	SELECT TOP 8	EstadoCuenta.FechaInicio,
					EstadoCuenta.FechaFinal,
					EstadoCuenta.SaldoInicial, 
					EstadoCuenta.SaldoFinal
					
	FROM EstadoCuenta 
	WHERE IdCuentaAhorro like 11687607
	ORDER BY FechaInicio DESC


	
	END TRY
	BEGIN CATCH


	END CATCH

END
