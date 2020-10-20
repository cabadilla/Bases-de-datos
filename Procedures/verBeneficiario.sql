CREATE PROCEDURE [dbo].[verBeneficiario]
@Id int

AS
BEGIN
SET NOCOUNT ON

	BEGIN TRY


	SELECT [Id]
      ,[Nombre]
      ,[IdCliente]
      ,[IdCuentaAhorros]
      ,[IdParentezco]
      ,[FechaNacimiento]
      ,[IdTipoDocumento]
  FROM [dbo].[Beneficiario]
  WHERE Id=@Id

	END TRY
	BEGIN CATCH


	END CATCH

END