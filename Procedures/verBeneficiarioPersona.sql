/****** Object:  StoredProcedure [dbo].[verBeneficiarioPersona]    Script Date: 12/12/2020 00:44:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[verBeneficiarioPersona]
@cuenta int
----Script para ver los datos del beneficiario y los datos de la persona que está vinculada por el valor del documento al beneficiario
AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY
		DECLARE @idCuenta int
		SELECT @idCuenta= Id FROM CuentaAhorros WHERE NumeroCuenta=@cuenta

		SELECT b.valorDocumentoIdentidad, b.porcentaje,p.Nombre,pe.Nombre,pe.FechaNacimiento,doc.Nombre,pe.Email,pe.Telefono1,pe.Telefono2
		FROM [dbo].[Beneficiario] b, Parentezco p,Persona pe,TipoDocumentoIdentidad Doc
		WHERE (b.IdCuentaAhorros=@idCuenta) AND (p.Id=b.IdParentezco) AND (b.isActivo=1) AND (pe.ValorDocumentoIdentidad=b.valorDocumentoIdentidad) AND (doc.Id=pe.IdTipoDocumentoIdentidad)
	END TRY
	BEGIN CATCH
	END CATCH

END

exec verBeneficiarioPersona 11064548

select * from CuentaAhorros