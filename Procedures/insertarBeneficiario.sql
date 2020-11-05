/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 4/11/2020 22:34:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarBeneficiario]

	
	@porcentaje float,
	@IdCuentaAhorros int,
	@IdParentezco int,
	@valorDocumentoIdentidad int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			INSERT INTO [dbo].[Beneficiario]
			   ([IdCuentaAhorros]
			   ,[IdParentezco]
			   ,[porcentaje]
			   ,[valorDocumentoIdentidad]
			   ,[isActivo])
			VALUES
			   (
				@IdCuentaAhorros,
				@IdParentezco,
				@porcentaje,
				@valorDocumentoIdentidad,
				1
			   )

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END