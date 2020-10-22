/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 22/10/2020 16:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[insertarPersona]
    -- Parámetros del SP
	@IdTipoDocumentoIdentidad int,
    @Nombre varchar(100),
	@ValorDocumentoIdentidad int,
	@FechaNacimiento date,
	@Email varchar(100),
	@Telefono1 int,
	@Telefono2 int

AS
BEGIN
SET NOCOUNT ON;
	BEGIN TRY  


		INSERT INTO [dbo].[Persona]
				   (
				   [IdTipoDocumentoIdentidad]
				   ,[Nombre]
				   ,[ValorDocumentoIdentidad]
				   ,[FechaNacimiento]
				   ,[Email]
				   ,[Telefono1]
				   ,[Telefono2])
			 VALUES
				   (@IdTipoDocumentoIdentidad
				   ,@Nombre
				   ,@ValorDocumentoIdentidad
				   ,@FechaNacimiento
				   ,@Email
				   ,@Telefono1
				   ,@Telefono2
				   )

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
