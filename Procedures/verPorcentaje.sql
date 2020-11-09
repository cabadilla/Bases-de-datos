/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 8/11/2020 18:17:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verPorcentaje]

	
	@IdCuentaAhorros int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			SELECT SUM(porcentaje)
			FROM Beneficiario WHERE (IdCuentaAhorros=@IdCuentaAhorros) and (isActivo=1)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END