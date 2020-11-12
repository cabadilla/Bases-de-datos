/****** Object:  StoredProcedure [dbo].[verBeneficiarioPersona]    Script Date: 11/11/2020 21:07:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verBeneficiarioPersona]
@idCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre,pe.Nombre,pe.FechaNacimiento,doc.Nombre,pe.Email,pe.Telefono1,pe.Telefono2
		FROM [dbo].[Beneficiario] b, Parentezco p,Persona pe,TipoDocumentoIdentidad Doc
		WHERE (b.IdCuentaAhorros=@idCuenta) and (p.Id=b.IdParentezco) and (b.isActivo=1) and (pe.ValorDocumentoIdentidad=b.valorDocumentoIdentidad) and (doc.Id=pe.IdTipoDocumentoIdentidad)
	END TRY
	BEGIN CATCH
	END CATCH

END


SELECT * FROM Usuario_Ver