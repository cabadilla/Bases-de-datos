/****** Object:  StoredProcedure [dbo].[verPorcentaje]    Script Date: 13/11/2020 21:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verPorcentaje]

	---Sp para ver la suma de porcentajes de beneficiarios en una cuenta
	@IdCuentaAhorros int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			SELECT SUM(porcentaje)
			FROM Beneficiario 
			WHERE (IdCuentaAhorros=@IdCuentaAhorros) AND (isActivo=1)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END