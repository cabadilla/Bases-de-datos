/****** Object:  StoredProcedure [dbo].[insertarBeneficiario]    Script Date: 19/10/2020 18:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarBeneficiario]

	@Nombre varchar(100),
	@IdCliente int,
	@IdCuentaAhorros int,
	@IdParentezco int,
	@FechaNacimiento date,
	@IdTipoDocumento int

	AS
	BEGIN 
	SET NOCOUNT ON
		BEGIN TRY

			INSERT INTO [dbo].[Beneficiario]
			   ([Nombre]
			   ,[IdCliente]
			   ,[IdCuentaAhorros]
			   ,[IdParentezco]
			   ,[FechaNacimiento]
			   ,[IdTipoDocumento])
			VALUES
			   (
				@Nombre,
				@IdCliente,
				@IdCuentaAhorros,
				@IdParentezco,
				@FechaNacimiento,
				@IdTipoDocumento

			   )

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END