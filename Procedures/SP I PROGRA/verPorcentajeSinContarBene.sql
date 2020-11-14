/****** Object:  StoredProcedure [dbo].[verPorcentaje]    Script Date: 13/11/2020 21:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verPorcentajeSinContarBene]

	---SP para ver el porcentaje de beneficiarios de una cuenta sin contar al beneficiario que se quiere editar
	@IdCuentaAhorros int,
	@valorDoc int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY
			SELECT SUM(porcentaje)
			FROM Beneficiario 
			WHERE (IdCuentaAhorros=@IdCuentaAhorros) and (isActivo=1) and (valorDocumentoIdentidad!=@valorDoc)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END