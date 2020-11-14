/****** Object:  StoredProcedure [dbo].[modificarBeneficiario]    Script Date: 10/11/2020 19:20:31 ******/
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
				WHERE (IdCuentaAhorros=@NumCuenta) AND (valorDocumentoIdentidad=@valorDocumento)

			UPDATE [dbo].[Persona]
			   SET [Nombre] = @nombre
				  
				WHERE (valorDocumentoIdentidad=@valorDocumento)

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END

	select * from Persona