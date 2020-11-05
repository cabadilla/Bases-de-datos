/****** Object:  StoredProcedure [dbo].[insertarPersona]    Script Date: 4/11/2020 22:45:55 ******/
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
				   ,[Telefono2]
				   ,[isActivo])
			 VALUES
				   (@IdTipoDocumentoIdentidad
				   ,@Nombre
				   ,@ValorDocumentoIdentidad
				   ,@FechaNacimiento
				   ,@Email
				   ,@Telefono1
				   ,@Telefono2
				   ,1
				   )

	END TRY
	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END