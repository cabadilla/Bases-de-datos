/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 7/12/2020 15:15:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[borrarBeneficiario]

@cuenta int,
@valorDoc int

AS
BEGIN 
SET NOCOUNT ON 
	BEGIN TRY
	declare @Existingdate datetime
	Set @Existingdate=GETDATE()
	Select CONVERT(varchar,@Existingdate,3) as [DD/MM/YY]

	UPDATE [dbo].[Beneficiario]
	   SET [fechaDesactivacion] =@Existingdate,
		   [isActivo] = 0
	   WHERE (IdCuentaAhorros=(SELECT Id FROM CuentaAhorros WHERE NumeroCuenta=@cuenta)) and (valorDocumentoIdentidad=@valorDoc)

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END