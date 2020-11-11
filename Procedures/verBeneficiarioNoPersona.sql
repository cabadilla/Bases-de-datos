/****** Object:  StoredProcedure [dbo].[verBeneficiario]    Script Date: 10/11/2020 18:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verBeneficiarioNoPersona]
@idCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre
		FROM [dbo].[Beneficiario] b, Parentezco p
		WHERE (b.IdCuentaAhorros=@idCuenta) and (p.Id=b.IdParentezco) and (b.isActivo=1)
	END TRY
	BEGIN CATCH
	END CATCH

END
