CREATE PROCEDURE [dbo].[modificarBeneficiario]
	@Id int,
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

			UPDATE [dbo].[Beneficiario]
			   SET [Nombre] = @Nombre
				  ,[IdCliente] = @IdCliente
				  ,[IdCuentaAhorros] = @IdCuentaAhorros
				  ,[IdParentezco] = @IdParentezco
				  ,[FechaNacimiento] = @FechaNacimiento
				  ,[IdTipoDocumento] = @IdTipoDocumento
				WHERE Id=@Id

		END TRY
		BEGIN CATCH

		END CATCH

	SET NOCOUNT OFF
	END