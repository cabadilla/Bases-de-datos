/****** Object:  StoredProcedure [dbo].[verBeneficiarioPersona]    Script Date: 11/11/2020 21:07:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verBeneficiarioPersona]
@idCuenta int
----Script para ver los datos del beneficiario y los datos de la persona que está vinculada por el valor del documento al beneficiario
AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre,pe.Nombre,pe.FechaNacimiento,doc.Nombre,pe.Email,pe.Telefono1,pe.Telefono2
		FROM [dbo].[Beneficiario] b, Parentezco p,Persona pe,TipoDocumentoIdentidad Doc
		WHERE (b.IdCuentaAhorros=@idCuenta) AND (p.Id=b.IdParentezco) AND (b.isActivo=1) AND (pe.ValorDocumentoIdentidad=b.valorDocumentoIdentidad) AND (doc.Id=pe.IdTipoDocumentoIdentidad)
	END TRY
	BEGIN CATCH
	END CATCH

END


SELECT * FROM Usuario_Ver