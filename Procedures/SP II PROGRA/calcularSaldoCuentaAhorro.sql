/****** Object:  StoredProcedure [dbo].[calcularSaldoCuentaAhorro]    Script Date: 7/12/2020 14:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[calcularSaldoCuentaAhorro]

@idCuenta int,
@monto float,
@tipo int,
@nuevoSaldo float output


AS
BEGIN 
SET NOCOUNT ON 

	BEGIN TRY

	DECLARE @saldoCuenta float
	DECLARE @tipoMov nchar(100)

	-----se ve si es un credito o debito
	SELECT @tipoMov=M.Tipo
	FROM TipoMovimientoCA M
	WHERE M.Id=@tipo

	SELECT @saldoCuenta=C.Saldo
	FROM CuentaAhorros C
	WHERE C.Id=@idCuenta
	
	IF @tipoMov='Debito'
		BEGIN
			SET @nuevoSaldo=@saldoCuenta-@monto
		END 
	ELSE
		BEGIN 
				
			SET @nuevoSaldo=@saldoCuenta+@monto
		END 

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50003,
		SUSER_SNAME(),
		ERROR_NUMBER(),
		ERROR_STATE(),
		ERROR_SEVERITY(),
		ERROR_LINE(),
		ERROR_PROCEDURE(),
		ERROR_MESSAGE(),
		GETDATE()
		);

	END CATCH

SET NOCOUNT OFF
END