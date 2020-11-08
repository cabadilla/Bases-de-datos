/****** Object:  StoredProcedure [dbo].[verBeneficiario]    Script Date: 7/11/2020 21:53:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verBeneficiario]
@idCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre
		FROM [dbo].[Beneficiario] b, Parentezco p
		WHERE (b.IdCuentaAhorros=@idCuenta) and (p.Id=b.IdParentezco) and(b.isActivo=1)
	END TRY
	BEGIN CATCH


	END CATCH

END
