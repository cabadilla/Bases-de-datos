/****** Object:  StoredProcedure [dbo].[verBeneficiario]    Script Date: 10/11/2020 18:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[verBeneficiarioPersona]
@idCuenta int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre,pe.Nombre,pe.FechaNacimiento,doc.Nombre
		FROM [dbo].[Beneficiario] b, Parentezco p,Persona pe,TipoDocumentoIdentidad Doc
		WHERE (b.IdCuentaAhorros=@idCuenta) and (p.Id=b.IdParentezco) and (b.isActivo=1) and (pe.ValorDocumentoIdentidad=b.valorDocumentoIdentidad) and (doc.Id=pe.IdTipoDocumentoIdentidad)
	END TRY
	BEGIN CATCH
	END CATCH

END

exec verBeneficiario 11260649

select * from Beneficiario
select * from Usuario
