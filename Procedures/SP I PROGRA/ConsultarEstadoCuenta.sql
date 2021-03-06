/****** Object:  StoredProcedure [dbo].[ConsultarEstadoCuenta]    Script Date: 2/12/2020 16:33:29 ******/
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
		

		DECLARE @valor INT
		SELECT @valor = P.Id
		FROM dbo.CuentaAhorros P
		WHERE P.NumeroCuenta = @Id	--se toma el id de ese valor de documento

		SELECT TOP 8	ec.FechaInicio,
						ec.FechaFinal,
						ec.SaldoInicial, 
						ec.SaldoFinal,
						ec.Id
					
		FROM  [dbo].[EstadoCuenta] ec
		WHERE (ec.IdCuentaAhorro = @valor) 
		ORDER BY FechaInicio DESC --Se ordenan

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END