/****** Object:  StoredProcedure [dbo].[buscarDescripcion]    Script Date: 7/12/2020 15:18:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[buscarDescripcion]
@valor nchar (100),
@numeroCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY

	DECLARE @idCuenta int
	SELECT @idCuenta= C.Id
	FROM CuentaAhorros C
	WHERE C.NumeroCuenta=@numeroCuenta

	DECLARE @idMov INT
	SELECT @idMov=M.IdTipoMovimientoCA
	FROM MovimientoCA M
	WHERE M.IdCuentaAhorros=@idCuenta

	DECLARE @movimiento nchar(100)
	SELECT @movimiento=T.Nombre
	FROM TipoMovimientoCA T
	WHERE T.Id=@idMov

	SELECT 
			[Fecha] ,
			Descripcion
			,[Monto] 
			,[NuevoSaldo]
			,@movimiento 
		FROM [dbo].[MovimientoCA] M
		WHERE M.Descripcion=@valor and M.IdCuentaAhorros=@idCuenta

	END TRY
	BEGIN CATCH
		INSERT INTO [dbo].[Errores] VALUES(
		50007,
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

END