/****** Object:  StoredProcedure [dbo].[modificarBeneficiario]    Script Date: 7/11/2020 23:45:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarBeneficiario]
	@NumCuenta int,
	@IdParentezco int,
	@valorDocumento int,
	@porcentaje int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[Beneficiario]
			   SET [IdParentezco] = @IdParentezco
				  ,[valorDocumentoIdentidad] = @valorDocumento
				  ,[porcentaje]=@porcentaje
				WHERE (IdCuentaAhorros=@NumCuenta) and (valorDocumentoIdentidad=@valorDocumento)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END