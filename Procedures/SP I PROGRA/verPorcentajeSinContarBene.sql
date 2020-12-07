/****** Object:  StoredProcedure [dbo].[verPorcentajeSinContarBene]    Script Date: 7/12/2020 15:08:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verPorcentajeSinContarBene]

	
	@IdCuentaAhorros int,
	@valorDoc int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			SELECT SUM(porcentaje)
			FROM Beneficiario 
			WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@IdCuentaAhorros )) and (isActivo=1) and (valorDocumentoIdentidad!=@valorDoc)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END