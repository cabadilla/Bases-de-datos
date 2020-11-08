/****** Object:  StoredProcedure [dbo].[borrarBeneficiario]    Script Date: 7/11/2020 23:50:49 ******/
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
	   WHERE (IdCuentaAhorros=@cuenta) and (valorDocumentoIdentidad=@valorDoc)

	END TRY
	BEGIN CATCH

	END CATCH

SET NOCOUNT OFF
END