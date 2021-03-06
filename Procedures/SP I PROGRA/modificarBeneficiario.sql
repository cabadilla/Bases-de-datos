/****** Object:  StoredProcedure [dbo].[modificarBeneficiario]    Script Date: 7/12/2020 15:09:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[modificarBeneficiario]
	@NumCuenta int,
	@IdParentezco int,
	@valorDocumento int,
	@porcentaje int,
	@nombre nchar(100)

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			UPDATE [dbo].[Beneficiario]
			   SET [IdParentezco] = @IdParentezco
				  ,[valorDocumentoIdentidad] = @valorDocumento
				  ,[porcentaje]=@porcentaje
				WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@NumCuenta )) and (valorDocumentoIdentidad=@valorDocumento)

			UPDATE [dbo].[Persona]
			   SET [Nombre] = @nombre
				  
				WHERE (valorDocumentoIdentidad=@valorDocumento)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END